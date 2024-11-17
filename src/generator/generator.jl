using LinearAlgebra

struct HGPC
    H1::Matrix{Int}
    H2::Matrix{Int}
    n1::Int
    k1::Int
    r1::Int
    n2::Int
    k2::Int
    r2::Int

    function HGPC(H1::Matrix{Int}, H2::Matrix{Int})
        if rank(H1) != size(H1, 1)
            println("Error! H1 doesn't have full rank!")
        end

        if rank(H2) != size(H2, 1)
            println("Error! H2 doesn't have full rank!")
        end

        new(
            H1,
            H2,
            size(H1, 2),
            size(H1, 2) - size(H1, 1),
            size(H1, 1),
            size(H2, 2),
            size(H2, 2) - size(H2, 1),
            size(H2, 1)
        )
    end
end

function construct_x(code::HGPC)
    I_n2 = LinearAlgebra.I(code.n2)
    I_r1 = LinearAlgebra.I(code.r1)
    left = kron(code.H1, I_n2)
    right = kron(I_r1, code.H2')
    x = hcat(left,right)
    return x
end

function construct_z(code::HGPC)
    I_n1 = LinearAlgebra.I(code.n1)
    I_r2 = LinearAlgebra.I(code.r2)
    left = kron(I_n1, code.H2)
    right = kron(code.H1', I_r2)
    z = hcat(left,right)
    return z
end

function construct_PCM(code::HGPC)
    x = construct_x(code)
    z = construct_z(code)
    height = size(x)[1] + size(z)[1]
    length = size(x)[2] + size(z)[2]
    PCM = Int.(zeros(height, length))
    PCM[1:size(x)[1], 1:size(x)[2]] .= copy(x)
    PCM[size(x)[1]+1:end, size(x)[2]+1:end] .= copy(z)
    return PCM
end

function get_tabular(Hx::Matrix{Int}, Hz::Matrix{Int})
    str_final = ""
    for i in 1:size(Hx, 1)
        str = ""
        row = Hx[i, :]
        for elem in row
            if elem == 1
                str = str*'X'
            else
                str = str*'_'
            end
        end
        str_final = str_final * str *'\n'
    end

    for i in 1:size(Hz, 1)
        str = ""
        row = Hz[i, :]
        for elem in row
            if elem == 1
                str = str*'Z'
            else
                str = str*'_'
            end
        end
        str_final = str_final * str *'\n'
    end
    return str_final
end
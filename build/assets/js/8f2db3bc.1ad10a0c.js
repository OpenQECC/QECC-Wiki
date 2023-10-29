"use strict";(self.webpackChunkqecc_wiki=self.webpackChunkqecc_wiki||[]).push([[2886],{3905:(e,t,r)=>{r.d(t,{Zo:()=>d,kt:()=>h});var n=r(7294);function i(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function o(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function a(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?o(Object(r),!0).forEach((function(t){i(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):o(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function l(e,t){if(null==e)return{};var r,n,i=function(e,t){if(null==e)return{};var r,n,i={},o=Object.keys(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||(i[r]=e[r]);return i}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(i[r]=e[r])}return i}var c=n.createContext({}),s=function(e){var t=n.useContext(c),r=t;return e&&(r="function"==typeof e?e(t):a(a({},t),e)),r},d=function(e){var t=s(e.components);return n.createElement(c.Provider,{value:t},e.children)},p="mdxType",u={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},m=n.forwardRef((function(e,t){var r=e.components,i=e.mdxType,o=e.originalType,c=e.parentName,d=l(e,["components","mdxType","originalType","parentName"]),p=s(r),m=i,h=p["".concat(c,".").concat(m)]||p[m]||u[m]||o;return r?n.createElement(h,a(a({ref:t},d),{},{components:r})):n.createElement(h,a({ref:t},d))}));function h(e,t){var r=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var o=r.length,a=new Array(o);a[0]=m;var l={};for(var c in t)hasOwnProperty.call(t,c)&&(l[c]=t[c]);l.originalType=e,l[p]="string"==typeof e?e:i,a[1]=l;for(var s=2;s<o;s++)a[s]=r[s];return n.createElement.apply(null,a)}return n.createElement.apply(null,r)}m.displayName="MDXCreateElement"},346:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>c,contentTitle:()=>a,default:()=>u,frontMatter:()=>o,metadata:()=>l,toc:()=>s});var n=r(7462),i=(r(7294),r(3905));const o={},a="Shor9",l={unversionedId:"codes/Shor-9",id:"codes/Shor-9",title:"Shor9",description:"Description",source:"@site/docs/codes/Shor-9.md",sourceDirName:"codes",slug:"/codes/Shor-9",permalink:"/QECC-Wiki/codes/Shor-9",draft:!1,editUrl:"https://github.com/Benzillaist/QECC-Wiki/docs/codes/Shor-9.md",tags:[],version:"current",frontMatter:{},sidebar:"api",previous:{title:"Bicycle",permalink:"/QECC-Wiki/codes/Bicycle"},next:{title:"Steane-7",permalink:"/QECC-Wiki/codes/Steane-7"}},c={},s=[{value:"Description",id:"description",level:2},{value:"Example",id:"example",level:2},{value:"Syndrome Circuit:",id:"syndrome-circuit",level:3},{value:"Benchmarking Results",id:"benchmarking-results",level:2},{value:"QASM Downloads",id:"qasm-downloads",level:2},{value:"Similar Codes",id:"similar-codes",level:2},{value:"References",id:"references",level:2}],d={toc:s},p="wrapper";function u(e){let{components:t,...o}=e;return(0,i.kt)(p,(0,n.Z)({},d,o,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("h1",{id:"shor9"},"Shor9"),(0,i.kt)("h2",{id:"description"},"Description"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Nine-qubit CSS code that is the first quantum error-correcting code.")),(0,i.kt)("h2",{id:"example"},"Example"),(0,i.kt)("p",null,"Code Tableau:"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre"},"ZZ_______\n_ZZ______\n___ZZ____\n____ZZ___\n______ZZ_\n_______ZZ\nXXXXXX___\n___XXXXXX\n")),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Number of qubits: N = 9"),(0,i.kt)("li",{parentName:"ul"},"Number of encoded bits: k = 1")),(0,i.kt)("h3",{id:"syndrome-circuit"},"Syndrome Circuit:"),(0,i.kt)("p",null,(0,i.kt)("img",{alt:"Shor-9 Syndrome Circuit",src:r(2251).Z,width:"6300",height:"3855"})),(0,i.kt)("h2",{id:"benchmarking-results"},"Benchmarking Results"),(0,i.kt)("p",null,"This code was tested with the following decoders:\n",(0,i.kt)("strong",{parentName:"p"},"Lookup table:")," Ran in 0.3843s\n",(0,i.kt)("img",{alt:"Shor-9 Truth Table PP",src:r(3815).Z,width:"500",height:"300"})),(0,i.kt)("p",null,(0,i.kt)("strong",{parentName:"p"},"Belief decoder:")," Ran in 42.28s"),(0,i.kt)("p",null,(0,i.kt)("img",{alt:"Shor-9 Belief Decoder PP",src:r(5583).Z,width:"500",height:"300"})),(0,i.kt)("h2",{id:""}),(0,i.kt)("h2",{id:"qasm-downloads"},"QASM Downloads"),(0,i.kt)("p",null,(0,i.kt)("a",{target:"_blank",href:r(245).Z},"Encoding Circuit")),(0,i.kt)("h2",{id:"similar-codes"},"Similar Codes"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("strong",{parentName:"li"},"[sample name]","(sample link)"),": short desc"),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("strong",{parentName:"li"},(0,i.kt)("a",{parentName:"strong",href:"https://www.nature.com/articles/s41586-022-05434-1"},"Surface Code")),": This is a surface code hehe")),(0,i.kt)("h2",{id:"references"},"References"),(0,i.kt)("p",null,"Nathanan Tantivasadakarn and Ruben Verresen and Ashvin Vishwanath, Shortest Route to Non-Abelian Topological Order on a Quantum Processor, Physical Review Letters, ",(0,i.kt)("a",{parentName:"p",href:"https://doi.org/10.1103/PhysRevLett.131.060405"},"DOI")))}u.isMDXComponent=!0},245:(e,t,r)=>{r.d(t,{Z:()=>n});const n=r.p+"assets/files/Shor-9-encodingCircuit-d471723536af4bd3e7c34592fb58c07e.qasm"},2251:(e,t,r)=>{r.d(t,{Z:()=>n});const n=r.p+"assets/images/Shor-9-codeplot-ec0d33067be3638324e51eeb31da7f76.png"},5583:(e,t,r)=>{r.d(t,{Z:()=>n});const n=r.p+"assets/images/Shor-9-beliefa-8deb2a71c19ab1a6925792b74c48cd4e.png"},3815:(e,t,r)=>{r.d(t,{Z:()=>n});const n=r.p+"assets/images/Shor-9-lookuptable-cb02552133795377dde348ff503dbc91.png"}}]);
"use strict";(self.webpackChunkqecc_wiki=self.webpackChunkqecc_wiki||[]).push([[2525],{3905:(e,t,r)=>{r.d(t,{Zo:()=>d,kt:()=>k});var n=r(7294);function a(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function l(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function o(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?l(Object(r),!0).forEach((function(t){a(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):l(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function i(e,t){if(null==e)return{};var r,n,a=function(e,t){if(null==e)return{};var r,n,a={},l=Object.keys(e);for(n=0;n<l.length;n++)r=l[n],t.indexOf(r)>=0||(a[r]=e[r]);return a}(e,t);if(Object.getOwnPropertySymbols){var l=Object.getOwnPropertySymbols(e);for(n=0;n<l.length;n++)r=l[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(a[r]=e[r])}return a}var c=n.createContext({}),p=function(e){var t=n.useContext(c),r=t;return e&&(r="function"==typeof e?e(t):o(o({},t),e)),r},d=function(e){var t=p(e.components);return n.createElement(c.Provider,{value:t},e.children)},u="mdxType",s={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},m=n.forwardRef((function(e,t){var r=e.components,a=e.mdxType,l=e.originalType,c=e.parentName,d=i(e,["components","mdxType","originalType","parentName"]),u=p(r),m=a,k=u["".concat(c,".").concat(m)]||u[m]||s[m]||l;return r?n.createElement(k,o(o({ref:t},d),{},{components:r})):n.createElement(k,o({ref:t},d))}));function k(e,t){var r=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var l=r.length,o=new Array(l);o[0]=m;var i={};for(var c in t)hasOwnProperty.call(t,c)&&(i[c]=t[c]);i.originalType=e,i[u]="string"==typeof e?e:a,o[1]=i;for(var p=2;p<l;p++)o[p]=r[p];return n.createElement.apply(null,o)}return n.createElement.apply(null,r)}m.displayName="MDXCreateElement"},5485:(e,t,r)=>{r.r(t),r.d(t,{contentTitle:()=>o,default:()=>u,frontMatter:()=>l,metadata:()=>i,toc:()=>c});var n=r(7462),a=(r(7294),r(3905));const l={},o="[Code Name]",i={type:"mdx",permalink:"/CodeTypeTemplate",source:"@site/src/pages/CodeTypeTemplate.md",title:"[Code Name]",description:"Code Description",frontMatter:{}},c=[{value:"Code Description",id:"code-description",level:2},{value:"Code Example",id:"code-example",level:2},{value:"Code tests",id:"code-tests",level:3},{value:"Code Generator",id:"code-generator",level:2},{value:"Code tests",id:"code-tests-1",level:3},{value:"Similar codes",id:"similar-codes",level:2},{value:"Code References",id:"code-references",level:2}],p={toc:c},d="wrapper";function u(e){let{components:t,...r}=e;return(0,a.kt)(d,(0,n.Z)({},p,r,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"code-name"},"[Code Name]"),(0,a.kt)("h2",{id:"code-description"},"Code Description"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"List of descriptive code attributes"),(0,a.kt)("li",{parentName:"ul"},"Similar to ",(0,a.kt)("a",{parentName:"li",href:"https://errorcorrectionzoo.org/"},"errorcorrectionzoo"))),(0,a.kt)("h2",{id:"code-example"},"Code Example"),(0,a.kt)("p",null,"[Insert image of small example of code][File Name]","(",(0,a.kt)("a",{parentName:"p",href:"https://github.com/Benzillaist/QECC-Wiki/link_to_code"},"https://github.com/Benzillaist/QECC-Wiki/link_to_code"),")"),(0,a.kt)("h3",{id:"code-tests"},"Code tests"),(0,a.kt)("p",null,"Graphs showing performance of code (physical vs logical error code)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Graph using decoder 1"),(0,a.kt)("li",{parentName:"ul"},"Graph using decoder 2"),(0,a.kt)("li",{parentName:"ul"},"Graph using decoder 3")),(0,a.kt)("h2",{id:"code-generator"},"Code Generator"),(0,a.kt)("p",null,"[Interactive code generator]","\nif code N < 15:"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Show code example"),(0,a.kt)("li",{parentName:"ul"},"Show download link")),(0,a.kt)("p",null,"else"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Show download link")),(0,a.kt)("h3",{id:"code-tests-1"},"Code tests"),(0,a.kt)("p",null,"Graphs showing performance of generated code, asuming code is smallish (like N < 1000)"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Graph using decoder 1"),(0,a.kt)("li",{parentName:"ul"},"Graph using decoder 2"),(0,a.kt)("li",{parentName:"ul"},"Graph using decoder 3")),(0,a.kt)("h2",{id:"similar-codes"},"Similar codes"),(0,a.kt)("p",null,"Here are codes that are similar in nature to the ","[code name]"),(0,a.kt)("table",null,(0,a.kt)("thead",{parentName:"table"},(0,a.kt)("tr",{parentName:"thead"},(0,a.kt)("th",{parentName:"tr",align:null},"Code"),(0,a.kt)("th",{parentName:"tr",align:null},"Description"))),(0,a.kt)("tbody",{parentName:"table"},(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},"Similar code #1"),(0,a.kt)("td",{parentName:"tr",align:null},"Similar code brief description #1")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},"Similar code #2"),(0,a.kt)("td",{parentName:"tr",align:null},"Similar code brief description #2")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},"Similar code #3"),(0,a.kt)("td",{parentName:"tr",align:null},"Similar code brief description #3")))),(0,a.kt)("h2",{id:"code-references"},"Code References"),(0,a.kt)("ol",null,(0,a.kt)("li",{parentName:"ol"},"Article/Journal reference #1"),(0,a.kt)("li",{parentName:"ol"},"Article/Journal reference #2"),(0,a.kt)("li",{parentName:"ol"},"Article/Journal reference #3")))}u.isMDXComponent=!0}}]);
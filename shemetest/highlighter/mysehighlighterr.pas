{ <PiNote - free source code editor>

Copyright (C) <2021> <Enzo Antonio Calogiuri> <ecalogiuri(at)gmail.com>

This source is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version.

This code is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

A copy of the GNU General Public License is available on the World Wide Web
at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
Boston, MA 02110-1335, USA.
}
unit MySEHighlighterR;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SynFacilHighlighter, SynEditHighlighter;

Type

  { TMySEHighlighterR }

  TMySEHighlighterR                 = Class(TSynFacilSyn)
     Private
      fKeyWordList                       : TStringList;
      tnFunctions                        : Integer;

     Protected
      function IsFilterStored: Boolean; override;
      function GetSampleSource: string; override;

     Public
      Constructor Create(AOwner: TComponent); Override;
      Destructor Destroy; Override;

      class function GetLanguageName: string; override;
    end;

implementation

Uses SynFacilBasic, SynEditStrConst;

Const
     SYNS_FilterR              = 'R files (*.r)|*.r';
     SYNS_LangR                = 'R';

     RKeyWords                 = 'break,else,FALSE,for,function,if,in,Inf,NA,' +
                                 'NA_character_,NA_complex_,NA_integer_,' +
                                 'NA_real_,NaN,next,NULL,repeat,TRUE,while';

     RFunctions                = 'abbreviate,abline,abs,acf,acos,acosh,addmargins,' +
                                 'aggregate,agrep,alarm,alias,alist,all,anova,' +
                                 'any,aov,aperm,append,apply,approx,approxfun,' +
                                 'apropos,ar,args,arima,array,arrows,asin,asinh,' +
                                 'assign,assocplot,atan,atanh,attach,attr,' +
                                 'attributes,autoload,autoloader,ave,axis,' +
                                 'backsolve,barplot,basename,beta,bindtextdomain,' +
                                 'binomial,biplot,bitmap,bmp,body,box,boxplot,' +
                                 'bquote,browser,builtins,bxp,by,bzfile,c,call,' +
                                 'cancor,capabilities,casefold,cat,category,' +
                                 'cbind,ccf,ceiling,character,charmatch,chartr,' +
                                 'chol,choose,chull,citation,class,close,cm,' +
                                 'cmdscale,codes,coef,coefficients,col,colnames,' +
                                 'colors,colorspaces,colours,comment,complex,' +
                                 'confint,conflicts,contour,contrasts,contributors,' +
                                 'convolve,cophenetic,coplot,cor,cos,cosh,cov,' +
                                 'covratio,cpgram,crossprod,cummax,cummin,cumprod,' +
                                 'cumsum,curve,cut,cutree,cycle,data,dataentry,' +
                                 'date,dbeta,dbinom,dcauchy,dchisq,de,debug,' +
                                 'debugger,decompose,delay,deltat,demo,dendrapply,' +
                                 'density,deparse,deriv,det,detach,determinant,' +
                                 'deviance,dexp,df,dfbeta,dfbetas,dffits,dgamma,' +
                                 'dgeom,dget,dhyper,diag,diff,diffinv,difftime,' +
                                 'digamma,dim,dimnames,dir,dirname,dist,dlnorm,' +
                                 'dlogis,dmultinom,dnbinom,dnorm,dotchart,double,' +
                                 'dpois,dput,drop,dsignrank,dt,dump,dunif,duplicated,' +
                                 'dweibull,dwilcox,eapply,ecdf,edit,effects,eigen,' +
                                 'emacs,embed,end,environment,eval,evalq,example,' +
                                 'exists,exp,expression,factanal,factor,factorial,' +
                                 'family,fft,fifo,file,filter,find,fitted,fivenum,' +
                                 'fix,floor,flush,force,formals,format,formula,' +
                                 'forwardsolve,fourfoldplot,frame,frequency,ftable,' +
                                 'gamma,gaussian,gc,gcinfo,gctorture,get,getenv,' +
                                 'geterrmessage,gettext,gettextf,getwd,gl,glm,globalenv,' +
                                 'gray,grep,grey,grid,gsub,gzcon,gzfile,hat,hatvalues,' +
                                 'hcl,hclust,head,heatmap,help,hist,history,hsv,' +
                                 'httpclient,iconv,iconvlist,identical,identify,' +
                                 'ifelse,image,influence,inherits,integer,integrate,' +
                                 'interaction,interactive,intersect,invisible,isoreg,' +
                                 'jitter,jpeg,julian,kappa,kernapply,kernel,kmeans,' +
                                 'knots,kronecker,ksmooth,labels,lag,lapply,layout,' +
                                 'lbeta,lchoose,lcm,legend,length,letters,levels,' +
                                 'lfactorial,lgamma,library,licence,license,line,' +
                                 'lines,list,lm,load,loadhistory,loadings,local,' +
                                 'locator,loess,log,logb,logical,loglin,lowess,ls,' +
                                 'lsfit,machine,mad,mahalanobis,makepredictcall,' +
                                 'manova,mapply,match,matlines,matplot,matpoints,' +
                                 'matrix,max,mean,median,medpolish,menu,merge,' +
                                 'message,methods,mget,min,missing,mode,monthplot,' +
                                 'months,mosaicplot,mtext,mvfft,names,napredict,' +
                                 'naprint,naresid,nargs,nchar,ncol,nextn,ngettext,' +
                                 'nlevels,nlm,nls,noquote,nrow,numeric,objects,' +
                                 'offset,open,optim,optimise,optimize,options,' +
                                 'order,ordered,outer,pacf,page,pairlist,pairs,' +
                                 'palette,par,parse,paste,pbeta,pbinom,pbirthday,' +
                                 'pcauchy,pchisq,pdf,pentagamma,person,persp,pexp,' +
                                 'pf,pgamma,pgeom,phyper,pi,pico,pictex,pie,piechart,' +
                                 'pipe,plclust,plnorm,plogis,plot,pmatch,pmax,pmin,' +
                                 'pnbinom,png,pnorm,points,poisson,poly,polygon,' +
                                 'polym,polyroot,postscript,power,ppoints,ppois,' +
                                 'ppr,prcomp,predict,preplot,pretty,princomp,print,' +
                                 'prmatrix,prod,profile,profiler,proj,promax,prompt,' +
                                 'provide,psigamma,psignrank,pt,ptukey,punif,pweibull,' +
                                 'pwilcox,q,qbeta,qbinom,qbirthday,qcauchy,qchisq,' +
                                 'qexp,qf,qgamma,qgeom,qhyper,qlnorm,qlogis,qnbinom,' +
                                 'qnorm,qpois,qqline,qqnorm,qqplot,qr,qsignrank,qt,' +
                                 'qtukey,quantile,quarters,quasi,quasibinomial,' +
                                 'quasipoisson,quit,qunif,quote,qweibull,qwilcox,' +
                                 'rainbow,range,rank,raw,rbeta,rbind,rbinom,rcauchy,' +
                                 'rchisq,readline,real,recover,rect,reformulate,' +
                                 'regexpr,relevel,remove,reorder,rep,replace,' +
                                 'replicate,replications,require,reshape,resid,residuals,' +
                                 'restart,return,rev,rexp,rf,rgamma,rgb,rgeom,' +
                                 'rhyper,rle,rlnorm,rlogis,rm,rmultinom,rnbinom,' +
                                 'rnorm,round,row,rownames,rowsum,rpois,rsignrank,' +
                                 'rstandard,rstudent,rt,rug,runif,runmed,rweibull,' +
                                 'rwilcox,sample,sapply,save,savehistory,scale,scan,' +
                                 'screen,screeplot,sd,search,searchpaths,seek,segments,' +
                                 'seq,sequence,serialize,setdiff,setequal,setwd,' +
                                 'shell,sign,signif,sin,single,sinh,sink,smooth,' +
                                 'solve,sort,source,spectrum,spline,splinefun,split,' +
                                 'sprintf,sqrt,stack,stars,start,stderr,stdin,stdout,' +
                                 'stem,step,stepfun,stl,stop,stopifnot,str,strftime,' +
                                 'strheight,stripchart,strptime,strsplit,strtrim,' +
                                 'structure,strwidth,strwrap,sub,subset,substitute,' +
                                 'substr,substring,sum,summary,sunflowerplot,supsmu,' +
                                 'svd,sweep,switch,symbols,symnum,system,t,table,' +
                                 'tabulate,tail,tan,tanh,tapply,tempdir,tempfile,' +
                                 'termplot,terms,tetragamma,text,time,title,toeplitz,' +
                                 'tolower,topenv,toupper,trace,traceback,transform,' +
                                 'trigamma,trunc,truncate,try,ts,tsdiag,tsp,typeof,' +
                                 'unclass,undebug,union,unique,uniroot,unix,unlink,' +
                                 'unlist,unname,unserialize,unsplit,unstack,untrace,' +
                                 'unz,update,upgrade,url,var,varimax,vcov,vector,' +
                                 'version,vi,vignette,warning,warnings,weekdays,weights,' +
                                 'which,window,windows,with,write,wsbrowser,xedit,' +
                                 'xemacs,xfig,xinch,xor,xtabs,xyinch,yinch,zapsmall';

{ TMySEHighlighterR }

function TMySEHighlighterR.IsFilterStored: Boolean;
begin
 Result := fDefaultFilter <> SYNS_FilterR;
end;

function TMySEHighlighterR.GetSampleSource: string;
begin
 Result := 'n <- .1 + 1.2 + 1e2 + 1e-2 + 1.2L + 1e-2L' + #13#10 +
           'n <- 10L + 1e3L + 0x0ABFFL' + #13#10 +
           'nStr <- '#39'Test' + #13#10 +
           'string'#39 + #13#10 +
           '' + #13#10 +
           'square <- function(x) {' + #13#10 +
           '  return(x*x)' + #13#10 +
           '}' + #13#10 +
           'cat("The square of 3 is ", square(3), "\n")' + #13#10 +
           '' + #13#10 +
           '# default value of the arg is set to 5.' + #13#10 +
           'cube <- function(x=5) {' + #13#10 +
           '  return(x*x*x);' + #13#10 +
           '}' + #13#10 +
           'cat("Calling cube with 2 : ", cube(2), "\n")    # will give 2^3' + #13#10 +
           '' + #13#10 +
           '  cat("Calling cube        : ", cube(), "\n")     # will default t' + #13#10 +
           '  o 5^3.';
end;

constructor TMySEHighlighterR.Create(AOwner: TComponent);
 Var I : Word;
begin
 fKeyWordList := TStringList.Create;
 fKeyWordList.Delimiter := ',';
 fKeyWordList.StrictDelimiter := True;

 fKeyWordList.DelimitedText := RKeyWords;

 Inherited Create(AOwner);

 ClearMethodTables;
 ClearSpecials;

 DefTokIdentif('[A-Za-z_]', '[A-Za-z0-9_]*');

 tnFunctions := NewTokType(SYNS_AttrFunction);

 For I := 0 To fKeyWordList.Count - 1 Do
  AddKeyword(fKeyWordList[I]);

 fKeyWordList.Clear;
 fKeyWordList.DelimitedText := RFunctions;

 For I := 0 To fKeyWordList.Count - 1 Do
  AddIdentSpec(fKeyWordList[I], tnFunctions);

 fKeyWordList.Free;

 DefTokDelim('"','"', tnString);
 DefTokDelim('''','''', tnString, tdMulLin);
 DefTokDelim('#','', tnComment);

 DefTokContent('[0123456789Le]','[0-9Le]', tnNumber);
 DefTokContent('0x','[0-9A-Fa-f]*', tnNumber);

 fDefaultFilter := SYNS_FilterR;

 Rebuild;

 SetAttributesOnChange(@DefHighlightChange);
end;

destructor TMySEHighlighterR.Destroy;
begin
  inherited Destroy;
end;

class function TMySEHighlighterR.GetLanguageName: string;
begin
 Result := SYNS_LangR;
end;

end.


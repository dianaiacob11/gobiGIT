% ---------------------------------------------------------------------
% Conference proceedings and article templates for
% personal open-archiving activities
% September 2012
% ---------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{SelfArx}[25/01/2012, v1.0]
\RequirePackage{ifthen}
\RequirePackage{calc}
\AtEndOfClass{\RequirePackage{microtype}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions*
\LoadClass{article}
\RequirePackage{ifpdf}      % Needed to pick between latex and pdflatex

%----------------------------------------------------------------------
%	FONTS
%----------------------------------------------------------------------

\RequirePackage{times}      % Loads the Times-Roman Fonts
\RequirePackage{mathptmx}   % Loads the Times-Roman Math Fonts

%----------------------------------------------------------------------
%	VARIOUS USEFUL PACKAGES
%----------------------------------------------------------------------

\RequirePackage[utf8]{inputenc}
\RequirePackage{amsmath,amsfonts,amssymb}
\RequirePackage{graphicx,xcolor}
\RequirePackage[english]{babel}
\RequirePackage{booktabs}
\usepackage{longtable}
\usepackage{microtype}
\usepackage{tabularx}
\usepackage{tabulary}
\usepackage{ltxtable}

%----------------------------------------------------------------------
%	MARGINS	
%----------------------------------------------------------------------
	  	  
\RequirePackage[left=2cm,%
                right=2cm,%
				top=2.25cm,%
				bottom=2.25cm,%
				headheight=11pt,%
				letterpaper]{geometry}%
				
%----------------------------------------------------------------------
%	FIGURES AND TABLES CAPTIONS
%----------------------------------------------------------------------
\usepackage{float}
\RequirePackage[labelfont={bf,sf,small},%
                labelsep=period,%
                singlelinecheck=false,
                justification=raggedright]{caption}
\setlength{\abovecaptionskip}{0pt}
\setlength{\belowcaptionskip}{0pt}
				
%----------------------------------------------------------------------
%	PAGE HEADER
%----------------------------------------------------------------------

\RequirePackage{fancyhdr}  % Needed to define custom headers/footers
\RequirePackage{lastpage}  % Number of pages in the document
\pagestyle{fancy}          % Enables the custom headers/footers
% Headers
\lhead{}%
\chead{}%
\rhead{\small\sffamily\@PaperTitle\  - \thepage/\pageref{LastPage}}
% Footers
\lfoot{}%
\cfoot{}%
\rfoot{}%
\renewcommand{\headrulewidth}{0pt}% % No header rule
\renewcommand{\footrulewidth}{0pt}% % No footer rule

%----------------------------------------------------------------------
%	SECTION/SUBSECTION/PARAGRAPH SET-UP
%----------------------------------------------------------------------

\RequirePackage[explicit]{titlesec}
\titleformat{\section}
  {\large\sffamily\bfseries}
  {}
  {0em}
  {\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\arabic{section}. #1}}
  []
\titleformat{name=\section,numberless}
  {\large\sffamily\bfseries}
  {}
  {0em}
  {\parbox{\dimexpr\linewidth-2\fboxsep\relax}{#1}}
  []  
\titleformat{\subsection}
  {\sffamily\bfseries}
  {\thesubsection}
  {0.5em}
  {#1}
  []
\titleformat{\subsubsection}
  {\sffamily\small\bfseries}
  {\thesubsubsection}
  {0.5em}
  {#1}
  []    
\titleformat{\paragraph}[runin]
  {\sffamily\small\bfseries}
  {}
  {0em}
  {#1} 
\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{5pt}
\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{0pt}
\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{0pt}
\titlespacing*{\paragraph}{0pc}{1.5ex \@plus2pt \@minus1pt}{10pt}

%----------------------------------------------------------------------
%	MULTIPLE AUTHOR SET
%----------------------------------------------------------------------  
  
\newcount\@authcnt
\newcount\@tmpcnt\@tmpcnt\z@

\def\@affiliation{%
  \ifnum\@tmpcnt<\@authcnt
   \global\advance\@tmpcnt1
    \raggedright \csname @auth\romannumeral\the\@tmpcnt\endcsname\hfill\\%
   \let\next\@affiliation \vskip1pt
  \else
   \let\next\relax
  \fi
\next}
	 
\newcommand{\affiliation}[1]{%
    \global\advance\@authcnt1
    \expandafter\gdef\csname @auth\romannumeral\the\@authcnt\endcsname
    {#1}}

	
%----------------------------------------------------------------------
%	LIST CONTROL
%----------------------------------------------------------------------  

\RequirePackage{enumitem}
%\setlist{nolistsep} % Uncomment to remove spacing between items in lists (enumerate, itemize)

%----------------------------------------------------------------------
%	ABSTRACT+AUTHOR FRAME
%----------------------------------------------------------------------  

\newcommand{\PaperTitle}[1]{\def\@PaperTitle{#1}}
\newcommand{\Archive}[1]{\def\@Archive{#1}}
\newcommand{\Authors}[1]{\def\@Authors{#1}}
\newcommand{\JournalInfo}[1]{\def\@JournalInfo{#1}}
\newcommand{\Abstract}[1]{\def\@Abstract{#1}}
\newcommand{\Keywords}[1]{\def\@Keywords{#1}}

% ---------------------------------------------------------------------

\renewcommand{\@maketitle}{%
\onecolumn{%
\thispagestyle{empty}%
\vskip20pt%
{\raggedright\sffamily\bfseries\fontsize{20}{25}\selectfont \@PaperTitle\par}%
\vskip10pt%
{\raggedright\sffamily\fontsize{12}{16}\selectfont  \@Authors\par}%
\vskip18pt%
\fcolorbox{color1}{white}{%
\parbox{\textwidth-2\fboxsep-2\fboxrule}{\centering%
\colorbox{color2!10}{%
\parbox{\textwidth-4\fboxsep-2\fboxrule}{%
\ifx\@Keywords\@empty%
\sffamily\textbf{\abstractname}\\\@Abstract%
\else%
\sffamily\textbf{\abstractname}\\\@Abstract\\[4pt]%
\textbf{\keywordname}\\\@Keywords%
\fi%
}%
}%
\vskip4pt%
\begingroup%
\raggedright\sffamily\small%
\footnotesize\@affiliation\par%
\endgroup%%
}%
}%
\vskip25pt%
}%
}%

%----------------------------------------------------------------------
%	REFERENCES
%----------------------------------------------------------------------  

% Remove brackets from numbering in List of References
\renewcommand{\@biblabel}[1]{\bfseries\color{color1}\textsuperscript{[#1]}}
%\setlength{\bibitemsep}{0cm}
\let\oldbibliography\thebibliography
\renewcommand{\thebibliography}[1]{%
\addcontentsline{toc}{section}{\refname}%
\oldbibliography{#1}%
\setlength\itemsep{0pt}}%
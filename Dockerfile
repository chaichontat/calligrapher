FROM r-base:latest

RUN apt-get update
RUN apt-get -y install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev \
    pandoc pandoc-citeproc wget curl git ghostscript

ENV TINYTEX_VERSION=2021.08
RUN R -e "options(Ncpus = 8); install.packages(c('tufte', 'distill', 'tinytex'))"
# In order to use github CDN.
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
RUN R -e "tinytex::tlmgr('install changepage ifmtarg paralist placeins sauerj tufte-latex xifthen hardwrap titlesec ragged2e textcase setspace palatino fancyhdr units ulem morefloats fpl mathpazo pdfcrop biblatex logreq')"

# In order to use pdfcrop.
ENV PATH="/root/.TinyTeX/bin/x86_64-linux:${PATH}"

RUN mkdir -p /github/workspace
WORKDIR /github/workspace

ENTRYPOINT r -e "rmarkdown::render(\"index.Rmd\", output_dir = \"./public\", output_format = \"all\")"

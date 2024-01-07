%let pgm=utl-add-a-column-to-an-existing-wps-r-python-dataframe-for-loop;

Add a column to an existing wps r python dataframe for loop


github
http://tinyurl.com/yj3dy54s
https://github.com/rogerjdeangelis/utl-add-a-column-to-an-existing-wps-r-python-dataframe-for-loop

stackoverflow R
http://tinyurl.com/mryr7x9v
https://stackoverflow.com/questions/77772772/dplyr-mutate-with-data-from-last-column

  SOLUTIONS

     1   wps
     2-4 wps sql/r/python only wps (same for all)
     5   wps r loop
     6   wps r base


/**************************************************************************************************************************/
/*            |                                                                |                                          */
/*   INPUT    |   PROCESS (Col 2*V2)                                           |  OUTPUT                                  */
/*            |                                                                |                                          */
/*  SD1.HAVE  |   WPS                                                          |   Same for all solutions                 */
/*            |   ===                                                          |   =======================                */
/*    X1 V2   |                                                                |                                          */
/*            |   data want;                                                   |     X1 V2 v3 (v3 added as 2*v2           */
/*  1  1  3   |    set  sd1.have;                                              |                                          */
/*  2  3  4   |    v3=2*v2;                                                    |   1  1  3  6                             */
/*            |   run;quit;                                                    |   2  3  4  8                             */
/*            |                                                                |                                          */
/*            |  SQL Same code in wps/R/Python                                 |                                          */
/*            |  =============================                                 |                                          */
/*            |                                                                |                                          */
/*            |   select                                                       |                                          */
/*            |      *                                                         |                                          */
/*            |     ,2*v2 as v3                                                |                                          */
/*            |   from                                                         |                                          */
/*            |      have                                                      |                                          */
/*            |                                                                |                                          */
/*            |  WPS R Loop                                                    |                                          */
/*            |  ==========                                                    |                                          */
/*            |                                                                |                                          */
/*            |  have$v3=NaN;                                                  |                                          */
/*            |  for (i in 1:nrow(have));                                      |                                          */
/*            |     {                                                          |                                          */
/*            |      have[i,3] <- 2*have[i,2];                                 |                                          */
/*            |     };                                                         |                                          */
/*            |  want <-have;                                                  |                                          */
/*            |                                                                |                                          */
/*            |  R base (mutate)                                               |                                          */
/*            |  ===============                                               |                                          */
/*            |                                                                |                                          */
/*            |  have %>%                                                      |                                          */
/*            |     mutate(across(last_col(), ~ .x * 2, .names = "V3"))        |                                          */
/*            |                                                                |                                          */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

libname sd1 "d:/sd1";
data sd1.have;
 input x1 v2;
cards4;
1 3
3 4
;;;;
run;quit;

/*
/ | __      ___ __  ___
| | \ \ /\ / / `_ \/ __|
| |  \ V  V /| |_) \__ \
|_|   \_/\_/ | .__/|___/
             |_|
*/

%utl_submit_wps64x("
libname sd1 'd:/sd1';
proc r;

 data want;
  set sd1.have;
  v3=3*v2;
 run;quit;

 proc print;
 run;quit;
");

/**************************************************************************************************************************/
/*                                                                                                                        */
/*    X1 V2 v3                                                                                                            */
/*                                                                                                                        */
/*  1  1  3  6                                                                                                            */
/*  2  3  4  8                                                                                                            */
/*                                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___       _  _               _                         __              __
|___ \     | || |    ___  __ _| | __      ___ __  ___   / / __  _   _   / / __
  __) |____| || |_  / __|/ _` | | \ \ /\ / / `_ \/ __| / / `_ \| | | | / / `__|
 / __/_____|__   _| \__ \ (_| | |  \ V  V /| |_) \__ \/ /| |_) | |_| |/ /| |
|_____|       |_|   |___/\__, |_|   \_/\_/ | .__/|___/_/ | .__/ \__, /_/ |_|
                            |_|            |_|           |_|    |___/
*/

%utl_submit_wps64x("
libname sd1 'd:/sd1';
proc r;
export data=sd1.have r=have;
submit;
library(sqldf);
want <-sqldf('
  select
     *
    ,2*v2 as v3
  from
     have
');
want;
endsubmit;
");

/*___                                 __              _
| ___|  __      ___ __  ___   _ __   / _| ___  _ __  | | ___   ___  _ __
|___ \  \ \ /\ / / `_ \/ __| | `__| | |_ / _ \| `__| | |/ _ \ / _ \| `_ \
 ___) |  \ V  V /| |_) \__ \ | |    |  _| (_) | |    | | (_) | (_) | |_) |
|____/    \_/\_/ | .__/|___/ |_|    |_|  \___/|_|    |_|\___/ \___/| .__/
                 |_|                                               |_|
*/


%utl_submit_wps64x("
libname sd1 'd:/sd1';
proc r;
export data=sd1.have r=have;
submit;
have$v3=NaN;
for (i in 1:nrow(have));
   {
    have[i,3] <- 2*have[i,2];
   };
want <-have;
want;
endsubmit;
");

/*__                                 _
 / /_   __      ___ __  ___   _ __  | |__   __ _ ___  ___
| `_ \  \ \ /\ / / `_ \/ __| | `__| | `_ \ / _` / __|/ _ \
| (_) |  \ V  V /| |_) \__ \ | |    | |_) | (_| \__ \  __/
 \___/    \_/\_/ | .__/|___/ |_|    |_.__/ \__,_|___/\___|
                 |_|
*/

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=df;
submit;
library(dplyr, warn=FALSE);
want<-df %>%
  mutate(across(last_col(), ~ .x * 2, .names = "V3"));
want;
endsubmit;
run;quit;
');

/**************************************************************************************************************************/
/*                                                                                                                        */
/* The WPS R System                                                                                                       */
/*                                                                                                                        */
/*   X1 V2 V3                                                                                                             */
/* 1  1  3  6                                                                                                             */
/* 2  3  4  8                                                                                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

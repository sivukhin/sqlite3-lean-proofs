import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000146

open Sqlite3Lean.Vdbe
open Sqlite3Lean.VdbeLemmas

/--
  Tables/Indexes (from VDBE):
    cursor=1 rootpage=3 db=0 mode=read name=
    cursor=0 rootpage=4 db=0 mode=read name=
    cursor=4 rootpage=3 db=0 mode=read name=
    cursor=5 rootpage=3 db=0 mode=read name=
    cursor=3 rootpage=4 db=0 mode=read name=
    cursor=8 rootpage=3 db=0 mode=read name=
    cursor=9 rootpage=3 db=0 mode=read name=
    cursor=7 rootpage=4 db=0 mode=read name=
    cursor=10 rootpage=3 db=0 mode=read name=
    cursor=11 rootpage=4 db=0 mode=read name=
    cursor=14 rootpage=3 db=0 mode=read name=
    cursor=15 rootpage=3 db=0 mode=read name=
    cursor=13 rootpage=4 db=0 mode=read name=
    cursor=17 rootpage=3 db=0 mode=read name=
    cursor=17 rootpage=3 db=0 mode=read name=

  Query: SELECT x FROM t2, t1 WHERE x BETWEEN c AND null OR x AND
    x IN ((SELECT x FROM (SELECT x FROM t2, t1 
    WHERE x BETWEEN (SELECT x FROM (SELECT x COLLATE rtrim 
    FROM t2, t1 WHERE x BETWEEN c AND null
    OR x AND x IN (c)), t1 WHERE x BETWEEN c AND null
    OR x AND x IN (c)) AND null
    OR NOT EXISTS(SELECT -4.81 FROM t1, t2 WHERE x BETWEEN c AND null
    OR x AND x IN ((SELECT x FROM (SELECT x FROM t2, t1
    WHERE x BETWEEN (SELECT x FROM (SELECT x BETWEEN c AND null
    OR x AND x IN (c)), t1 WHERE x BETWEEN c AND null
    OR x AND x IN (c)) AND null
    OR x AND x IN (c)), t1 WHERE x BETWEEN c AND null
    OR x AND x IN (c)))) AND x IN (c)
    ), t1 WHERE x BETWEEN c AND null
    OR x AND x IN (c)));

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     404   0                    0   
  1     OpenRead       1     3     0     1              0   
  2     OpenRead       0     4     0     1              0   
  3     Rewind         1     403   0                    0   
  4     Null           0     2     0                    0   
  5     Integer        398   1     0                    0   
  6     ReopenIdx      18    5     0     k(2,,)         0   
  7     Column         1     0     4                    0   
  8     IsNull         4     18    0                    0   
  9     SeekGE         18    18    4     1              0   
  10    Null           0     4     0                    0   
  11    IsNull         4     18    0                    0   
  12    IdxGT          18    18    4     1              0   
  13    DeferredSeek   18    0     0     [1,0]          0   
  14    IdxRowid       18    3     0                    0   
  15    RowSetTest     2     17    3     0              0   
  16    Gosub          1     399   0                    0   
  17    Next           18    12    0                    0   
  18    ReopenIdx      18    5     0     k(2,,)         2   
  19    BeginSubrtn    0     6     0     subrtnsig:9,A  0   
  20    Once           0     385   7                    0   
  21    OpenEphemeral  19    1     0     k(1,B)         0   
  22    Blob           10000  7     0                    0   
  23    OpenRead       4     3     0     1              0   
  24    OpenRead       5     3     0     1              0   
  25    OpenRead       3     4     0     1              0   
  26    IfEmpty        3     384   0                    0   
  27    Rewind         4     384   0                    0   
  28    Rewind         5     384   0                    0   
  29    Null           0     9     0                    0   
  30    Integer        367   8     0                    0   
  31    ReopenIdx      20    5     0     k(2,,)         0   
  32    BeginSubrtn    0     12    0                    0   
  33    Once           0     109   0                    0   
  34    Null           0     13    13                   0   
  35    Integer        1     14    0                    0   
  36    OpenRead       8     3     0     1              0   
  37    OpenRead       9     3     0     1              0   
  38    OpenRead       7     4     0     1              0   
  39    IfEmpty        7     109   0                    0   
  40    Rewind         8     109   0                    0   
  41    Rewind         9     109   0                    0   
  42    Null           0     16    0                    0   
  43    Integer        93    15    0                    0   
  44    ReopenIdx      21    5     0     k(2,,)         0   
  45    Column         8     0     18                   0   
  46    IsNull         18    65    0                    0   
  47    SeekGE         21    65    18    1              0   
  48    Null           0     18    0                    0   
  49    IsNull         18    65    0                    0   
  50    IdxGT          21    65    18    1              0   
  51    DeferredSeek   21    0     7     [1,0]          0   
  52    Column         21    0     19                   0   
  53    Column         9     0     20                   0   
  54    Lt             20    56    19    RTRIM-8        81  
  55    Le             21    61    19    RTRIM-8        65  
  56    Column         21    0     19                   0   
  57    IfNot          19    64    1                    0   
  58    Column         21    0     19                   0   
  59    Column         9     0     20                   0   
  60    Ne             19    64    20    RTRIM-8        81  
  61    IdxRowid       21    17    0                    0   
  62    RowSetTest     16    64    17    0              0   
  63    Gosub          15    94    0                    0   
  64    Next           21    50    0                    0   
  65    ReopenIdx      21    5     0     k(2,,)         2   
  66    Noop           0     23    0                    0   
  67    Noop           0     0     0                    0   
  68    OpenEphemeral  22    1     0     k(1,B)         0   
  69    Column         8     0     20                   0   
  70    MakeRecord     20    1     24    A              0   
  71    IdxInsert      22    24    20    1              0   
  72    Rewind         22    93    0                    0   
  73    Column         22    0     22                   0   
  74    IsNull         22    92    0                    0   
  75    SeekGE         21    92    22    1              0   
  76    IdxGT          21    92    22    1              0   
  77    DeferredSeek   21    0     7     [1,0]          0   
  78    Column         21    0     24                   0   
  79    IfNot          24    92    1                    0   
  80    Column         21    0     24                   0   
  81    Column         9     0     20                   0   
  82    Lt             20    84    24    RTRIM-8        81  
  83    Le             21    89    24    RTRIM-8        65  
  84    Column         21    0     24                   0   
  85    IfNot          24    92    1                    0   
  86    Column         21    0     24                   0   
  87    Column         9     0     20                   0   
  88    Ne             24    92    20    RTRIM-8        81  
  89    IdxRowid       21    17    0                    0   
  90    RowSetTest     16    92    17    -1             0   
  91    Gosub          15    94    0                    0   
  92    Next           22    73    0                    0   
  93    Goto           0     107   0                    0   
  94    Column         21    0     20                   0   
  95    Column         9     0     25                   0   
  96    Lt             25    98    20    RTRIM-8        81  
  97    Le             21    103   20    RTRIM-8        65  
  98    Column         21    0     20                   0   
  99    IfNot          20    106   1                    0   
  100   Column         21    0     20                   0   
  101   Column         9     0     25                   0   
  102   Ne             20    106   25    RTRIM-8        81  
  103   Column         21    0     13                   0   
  104   ClrSubtype     13    0     0                    0   
  105   DecrJumpZero   14    109   0                    0   
  106   Return         15    94    0                    0   
  107   Next           9     42    0                    1   
  108   Next           8     41    0                    1   
  109   Return         12    33    1                    0   
  110   Copy           13    11    0                    0   
  111   IsNull         11    130   0                    0   
  112   SeekGE         20    130   11    1              0   
  113   Null           0     11    0                    0   
  114   IsNull         11    130   0                    0   
  115   IdxGT          20    130   11    1              0   
  116   DeferredSeek   20    0     3     [1,0]          0   
  117   Column         20    0     26                   0   
  118   Column         5     0     27                   0   
  119   Lt             27    121   26    BINARY-8       81  
  120   Le             21    126   26    BINARY-8       65  
  121   Column         20    0     26                   0   
  122   IfNot          26    129   1                    0   
  123   Column         20    0     26                   0   
  124   Column         5     0     27                   0   
  125   Ne             26    129   27    BINARY-8       81  
  126   IdxRowid       20    10    0                    0   
  127   RowSetTest     9     129   10    0              0   
  128   Gosub          8     368   0                    0   
  129   Next           20    115   0                    0   
  130   ReopenIdx      20    5     0     k(2,,)         2   
  131   Noop           0     29    0                    0   
  132   Noop           0     0     0                    0   
  133   OpenEphemeral  23    1     0     k(1,B)         0   
  134   Column         4     0     27                   0   
  135   MakeRecord     27    1     30    A              0   
  136   IdxInsert      23    30    27    1              0   
  137   Rewind         23    367   0                    0   
  138   Column         23    0     28                   0   
  139   IsNull         28    366   0                    0   
  140   SeekGE         20    366   28    1              0   
  141   IdxGT          20    366   28    1              0   
  142   DeferredSeek   20    0     3     [1,0]          0   
  143   Column         20    0     30                   0   
  144   Column         5     0     27                   0   
  145   Lt             27    147   30    BINARY-8       81  
  146   Le             21    152   30    BINARY-8       65  
  147   Column         20    0     30                   0   
  148   IfNot          30    366   1                    0   
  149   Column         20    0     30                   0   
  150   Column         5     0     27                   0   
  151   Ne             30    366   27    BINARY-8       81  
  152   BeginSubrtn    0     31    0                    0   
  153   Once           0     361   0                    0   
  154   Integer        0     32    0                    0   
  155   Integer        1     33    0                    0   
  156   OpenRead       10    3     0     1              0   
  157   OpenRead       11    4     0     1              0   
  158   Rewind         10    361   0                    0   
  159   Null           0     35    0                    0   
  160   Integer        356   34    0                    0   
  161   ReopenIdx      24    5     0     k(2,,)         0   
  162   Column         10    0     37                   0   
  163   IsNull         37    173   0                    0   
  164   SeekGE         24    173   37    1              0   
  165   Null           0     37    0                    0   
  166   IsNull         37    173   0                    0   
  167   IdxGT          24    173   37    1              0   
  168   DeferredSeek   24    0     11    [1,0]          0   
  169   IdxRowid       24    36    0                    0   
  170   RowSetTest     35    172   36    0              0   
  171   Gosub          34    357   0                    0   
  172   Next           24    167   0                    0   
  173   ReopenIdx      24    5     0     k(2,,)         2   
  174   BeginSubrtn    0     39    0     subrtnsig:6,A  0   
  175   Once           0     343   40                   0   
  176   OpenEphemeral  25    1     0     k(1,B)         0   
  177   Blob           10000  40    0                    0   
  178   OpenRead       14    3     0     1              0   
  179   OpenRead       15    3     0     1              0   
  180   OpenRead       13    4     0     1              0   
  181   IfEmpty        13    342   0                    0   
  182   Rewind         14    342   0                    0   
  183   Rewind         15    342   0                    0   
  184   Null           0     42    0                    0   
  185   Integer        280   41    0                    0   
  186   ReopenIdx      26    5     0     k(2,,)         0   
  187   Column         15    0     44                   0   
  188   IsNull         44    252   0                    0   
  189   SeekGE         26    252   44    1              0   
  190   Null           0     44    0                    0   
  191   IsNull         44    252   0                    0   
  192   IdxGT          26    252   44    1              0   
  193   DeferredSeek   26    0     13    [1,0]          0   
  194   Column         26    0     45                   0   
  195   BeginSubrtn    0     47    0                    0   
  196   Null           0     48    48                   0   
  197   InitCoroutine  49    222   198                  0   
  198   Column         26    0     52                   0   
  199   Column         14    0     54                   0   
  200   Integer        1     53    0                    0   
  201   Ge             54    203   52    BINARY-8       65  
  202   ZeroOrNull     52    53    54                   0   
  203   Integer        1     54    0                    0   
  204   Le             21    206   52    BINARY-8       65  
  205   ZeroOrNull     52    54    21                   0   
  206   And            54    53    51                   0   
  207   Column         26    0     54                   0   
  208   Null           0     53    0                    0   
  209   Column         26    0     55                   0   
  210   BitAnd         55    55    56                   0   
  211   Column         14    0     57                   0   
  212   BitAnd         56    57    56                   0   
  213   Eq             55    216   57    BINARY-8       65  
  214   IsNull         56    218   0                    0   
  215   Goto           0     217   0                    0   
  216   Integer        1     53    0                    0   
  217   AddImm         53    0     0                    0   
  218   And            53    54    52                   0   
  219   Or             52    51    50                   0   
  220   Yield          49    0     0                    0   
  221   EndCoroutine   49    0     0                    0   
  222   Integer        1     58    0                    0   
  223   OpenRead       17    3     0     1              0   
  224   InitCoroutine  49    0     198                  0   
  225   Yield          49    240   0                    0   
  226   Rewind         17    240   0                    0   
  227   Column         26    0     59                   0   
  228   Column         17    0     60                   0   
  229   Lt             60    231   59    BINARY-8       81  
  230   Le             21    236   59    BINARY-8       65  
  231   Column         26    0     59                   0   
  232   IfNot          59    238   1                    0   
  233   Column         26    0     59                   0   
  234   Column         17    0     60                   0   
  235   Ne             59    238   60    BINARY-8       81  
  236   Column         26    0     48                   0   
  237   DecrJumpZero   58    240   0                    0   
  238   Next           17    227   0                    1   
  239   Goto           0     225   0                    0   
  240   Return         47    196   1                    0   
  241   Lt             48    243   45    BINARY-8       81  
  242   Le             21    248   45    BINARY-8       65  
  243   Column         26    0     45                   0   
  244   IfNot          45    251   1                    0   
  245   Column         26    0     45                   0   
  246   Column         14    0     46                   0   
  247   Ne             45    251   46    BINARY-8       81  
  248   IdxRowid       26    43    0                    0   
  249   RowSetTest     42    251   43    0              0   
  250   Gosub          41    281   0                    0   
  251   Next           26    192   0                    0   
  252   ReopenIdx      26    5     0     k(2,,)         2   
  253   Noop           0     62    0                    0   
  254   Noop           0     0     0                    0   
  255   OpenEphemeral  27    1     0     k(1,B)         0   
  256   Column         15    0     46                   0   
  257   MakeRecord     46    1     63    A              0   
  258   IdxInsert      27    63    46    1              0   
  259   Rewind         27    280   0                    0   
  260   Column         27    0     61                   0   
  261   IsNull         61    279   0                    0   
  262   SeekGE         26    279   61    1              0   
  263   IdxGT          26    279   61    1              0   
  264   DeferredSeek   26    0     13    [1,0]          0   
  265   Column         26    0     63                   0   
  266   IfNot          63    279   1                    0   
  267   Column         26    0     63                   0   
  268   Gosub          47    196   0                    0   
  269   Lt             48    271   63    BINARY-8       81  
  270   Le             21    276   63    BINARY-8       65  
  271   Column         26    0     63                   0   
  272   IfNot          63    279   1                    0   
  273   Column         26    0     63                   0   
  274   Column         14    0     46                   0   
  275   Ne             63    279   46    BINARY-8       81  
  276   IdxRowid       26    43    0                    0   
  277   RowSetTest     42    279   43    -1             0   
  278   Gosub          41    281   0                    0   
  279   Next           27    260   0                    0   
  280   Goto           0     340   0                    0   
  281   Column         26    0     46                   0   
  282   BeginSubrtn    0     65    0                    0   
  283   Null           0     66    66                   0   
  284   InitCoroutine  67    309   285                  0   
  285   Column         26    0     70                   0   
  286   Column         14    0     72                   0   
  287   Integer        1     71    0                    0   
  288   Ge             72    290   70    BINARY-8       65  
  289   ZeroOrNull     70    71    72                   0   
  290   Integer        1     72    0                    0   
  291   Le             21    293   70    BINARY-8       65  
  292   ZeroOrNull     70    72    21                   0   
  293   And            72    71    69                   0   
  294   Column         26    0     72                   0   
  295   Null           0     71    0                    0   
  296   Column         26    0     73                   0   
  297   BitAnd         73    73    74                   0   
  298   Column         14    0     75                   0   
  299   BitAnd         74    75    74                   0   
  300   Eq             73    303   75    BINARY-8       65  
  301   IsNull         74    305   0                    0   
  302   Goto           0     304   0                    0   
  303   Integer        1     71    0                    0   
  304   AddImm         71    0     0                    0   
  305   And            71    72    70                   0   
  306   Or             70    69    68                   0   
  307   Yield          67    0     0                    0   
  308   EndCoroutine   67    0     0                    0   
  309   Integer        1     76    0                    0   
  310   OpenRead       17    3     0     1              0   
  311   InitCoroutine  67    0     285                  0   
  312   Yield          67    327   0                    0   
  313   Rewind         17    327   0                    0   
  314   Column         26    0     77                   0   
  315   Column         17    0     78                   0   
  316   Lt             78    318   77    BINARY-8       81  
  317   Le             21    323   77    BINARY-8       65  
  318   Column         26    0     77                   0   
  319   IfNot          77    325   1                    0   
  320   Column         26    0     77                   0   
  321   Column         17    0     78                   0   
  322   Ne             77    325   78    BINARY-8       81  
  323   Column         26    0     66                   0   
  324   DecrJumpZero   76    327   0                    0   
  325   Next           17    314   0                    1   
  326   Goto           0     312   0                    0   
  327   Return         65    283   1                    0   
  328   Lt             66    330   46    BINARY-8       81  
  329   Le             21    335   46    BINARY-8       65  
  330   Column         26    0     46                   0   
  331   IfNot          46    339   1                    0   
  332   Column         26    0     46                   0   
  333   Column         14    0     64                   0   
  334   Ne             46    339   64    BINARY-8       81  
  335   Column         26    0     79                   0   
  336   MakeRecord     79    1     64    A              0   
  337   IdxInsert      25    64    79    1              0   
  338   FilterAdd      40    0     79    1              0   
  339   Return         41    281   0                    0   
  340   Next           15    184   0                    1   
  341   Next           14    183   0                    1   
  342   NullRow        25    0     0                    0   
  343   Return         39    175   1                    0   
  344   Rewind         25    356   0                    0   
  345   Column         25    0     38                   0   
  346   IsNull         38    355   0                    0   
  347   SeekGE         24    355   38    1              0   
  348   IdxGT          24    355   38    1              0   
  349   DeferredSeek   24    0     11    [1,0]          0   
  350   Column         24    0     80                   0   
  351   IfNot          80    355   1                    0   
  352   IdxRowid       24    36    0                    0   
  353   RowSetTest     35    355   36    -1             0   
  354   Gosub          34    357   0                    0   
  355   Next           25    345   0                    0   
  356   Goto           0     360   0                    0   
  357   Integer        1     32    0                    0   
  358   DecrJumpZero   33    361   0                    0   
  359   Return         34    357   0                    0   
  360   Next           10    159   0                    1   
  361   Return         31    153   1                    0   
  362   If             32    366   1                    0   
  363   IdxRowid       20    10    0                    0   
  364   RowSetTest     9     366   10    -1             0   
  365   Gosub          8     368   0                    0   
  366   Next           23    138   0                    0   
  367   Goto           0     382   0                    0   
  368   Column         20    0     27                   0   
  369   Column         5     0     82                   0   
  370   Lt             82    372   27    BINARY-8       81  
  371   Le             21    377   27    BINARY-8       65  
  372   Column         20    0     27                   0   
  373   IfNot          27    381   1                    0   
  374   Column         20    0     27                   0   
  375   Column         5     0     82                   0   
  376   Ne             27    381   82    BINARY-8       81  
  377   Column         20    0     83                   0   
  378   MakeRecord     83    1     82    A              0   
  379   IdxInsert      19    82    83    1              0   
  380   FilterAdd      7     0     83    1              0   
  381   Return         8     368   0                    0   
  382   Next           5     29    0                    1   
  383   Next           4     28    0                    1   
  384   NullRow        19    0     0                    0   
  385   Return         6     20    1                    0   
  386   Rewind         19    398   0                    0   
  387   Column         19    0     5                    0   
  388   IsNull         5     397   0                    0   
  389   SeekGE         18    397   5     1              0   
  390   IdxGT          18    397   5     1              0   
  391   DeferredSeek   18    0     0     [1,0]          0   
  392   Column         18    0     84                   0   
  393   IfNot          84    397   1                    0   
  394   IdxRowid       18    3     0                    0   
  395   RowSetTest     2     397   3     -1             0   
  396   Gosub          1     399   0                    0   
  397   Next           19    387   0                    0   
  398   Goto           0     402   0                    0   
  399   Column         18    0     85                   0   
  400   ResultRow      85    1     0                    0   
  401   Return         1     399   0                    0   
  402   Next           1     4     0                    1   
  403   Halt           0     0     0                    0   
  404   Transaction    0     0     29    1              1   
  405   Null           0     21    0                    0   
  406   Goto           0     1     0                    0   
-/

def program : Program := #[
  .init 0 404 0 0 0,  -- 0: Init
  .openRead 1 3 0 1 0,  -- 1: OpenRead
  .openRead 0 4 0 1 0,  -- 2: OpenRead
  .rewind 1 403 0 0 0,  -- 3: Rewind
  .null 0 2 0 0 0,  -- 4: Null
  .integer 398 1 0 0 0,  -- 5: Integer
  .reopenIdx 18 5 0 "k(2,,)" 0,  -- 6: ReopenIdx
  .column 1 0 4 0 0,  -- 7: Column
  .isNull 4 18 0 0 0,  -- 8: IsNull
  .seekGE 18 18 4 1 0,  -- 9: SeekGE
  .null 0 4 0 0 0,  -- 10: Null
  .isNull 4 18 0 0 0,  -- 11: IsNull
  .idxGT 18 18 4 1 0,  -- 12: IdxGT
  .deferredSeek 18 0 0 "[1,0]" 0,  -- 13: DeferredSeek
  .idxRowid 18 3 0 0 0,  -- 14: IdxRowid
  .rowSetTest 2 17 3 0 0,  -- 15: RowSetTest
  .gosub 1 399 0 0 0,  -- 16: Gosub
  .next 18 12 0 0 0,  -- 17: Next
  .reopenIdx 18 5 0 "k(2,,)" 2,  -- 18: ReopenIdx
  .beginSubrtn 0 6 0 "subrtnsig:9,A" 0,  -- 19: BeginSubrtn
  .once 0 385 7 0 0,  -- 20: Once
  .openEphemeral 19 1 0 "k(1,B)" 0,  -- 21: OpenEphemeral
  .blob 10000 7 0 0 0,  -- 22: Blob
  .openRead 4 3 0 1 0,  -- 23: OpenRead
  .openRead 5 3 0 1 0,  -- 24: OpenRead
  .openRead 3 4 0 1 0,  -- 25: OpenRead
  .ifEmpty 3 384 0 0 0,  -- 26: IfEmpty
  .rewind 4 384 0 0 0,  -- 27: Rewind
  .rewind 5 384 0 0 0,  -- 28: Rewind
  .null 0 9 0 0 0,  -- 29: Null
  .integer 367 8 0 0 0,  -- 30: Integer
  .reopenIdx 20 5 0 "k(2,,)" 0,  -- 31: ReopenIdx
  .beginSubrtn 0 12 0 0 0,  -- 32: BeginSubrtn
  .once 0 109 0 0 0,  -- 33: Once
  .null 0 13 13 0 0,  -- 34: Null
  .integer 1 14 0 0 0,  -- 35: Integer
  .openRead 8 3 0 1 0,  -- 36: OpenRead
  .openRead 9 3 0 1 0,  -- 37: OpenRead
  .openRead 7 4 0 1 0,  -- 38: OpenRead
  .ifEmpty 7 109 0 0 0,  -- 39: IfEmpty
  .rewind 8 109 0 0 0,  -- 40: Rewind
  .rewind 9 109 0 0 0,  -- 41: Rewind
  .null 0 16 0 0 0,  -- 42: Null
  .integer 93 15 0 0 0,  -- 43: Integer
  .reopenIdx 21 5 0 "k(2,,)" 0,  -- 44: ReopenIdx
  .column 8 0 18 0 0,  -- 45: Column
  .isNull 18 65 0 0 0,  -- 46: IsNull
  .seekGE 21 65 18 1 0,  -- 47: SeekGE
  .null 0 18 0 0 0,  -- 48: Null
  .isNull 18 65 0 0 0,  -- 49: IsNull
  .idxGT 21 65 18 1 0,  -- 50: IdxGT
  .deferredSeek 21 0 7 "[1,0]" 0,  -- 51: DeferredSeek
  .column 21 0 19 0 0,  -- 52: Column
  .column 9 0 20 0 0,  -- 53: Column
  .lt 20 56 19 "RTRIM-8" 81,  -- 54: Lt
  .le 21 61 19 "RTRIM-8" 65,  -- 55: Le
  .column 21 0 19 0 0,  -- 56: Column
  .ifNot 19 64 1 0 0,  -- 57: IfNot
  .column 21 0 19 0 0,  -- 58: Column
  .column 9 0 20 0 0,  -- 59: Column
  .ne 19 64 20 "RTRIM-8" 81,  -- 60: Ne
  .idxRowid 21 17 0 0 0,  -- 61: IdxRowid
  .rowSetTest 16 64 17 0 0,  -- 62: RowSetTest
  .gosub 15 94 0 0 0,  -- 63: Gosub
  .next 21 50 0 0 0,  -- 64: Next
  .reopenIdx 21 5 0 "k(2,,)" 2,  -- 65: ReopenIdx
  .noop 0 23 0 0 0,  -- 66: Noop
  .noop 0 0 0 0 0,  -- 67: Noop
  .openEphemeral 22 1 0 "k(1,B)" 0,  -- 68: OpenEphemeral
  .column 8 0 20 0 0,  -- 69: Column
  .makeRecord 20 1 24 "A" 0,  -- 70: MakeRecord
  .idxInsert 22 24 20 1 0,  -- 71: IdxInsert
  .rewind 22 93 0 0 0,  -- 72: Rewind
  .column 22 0 22 0 0,  -- 73: Column
  .isNull 22 92 0 0 0,  -- 74: IsNull
  .seekGE 21 92 22 1 0,  -- 75: SeekGE
  .idxGT 21 92 22 1 0,  -- 76: IdxGT
  .deferredSeek 21 0 7 "[1,0]" 0,  -- 77: DeferredSeek
  .column 21 0 24 0 0,  -- 78: Column
  .ifNot 24 92 1 0 0,  -- 79: IfNot
  .column 21 0 24 0 0,  -- 80: Column
  .column 9 0 20 0 0,  -- 81: Column
  .lt 20 84 24 "RTRIM-8" 81,  -- 82: Lt
  .le 21 89 24 "RTRIM-8" 65,  -- 83: Le
  .column 21 0 24 0 0,  -- 84: Column
  .ifNot 24 92 1 0 0,  -- 85: IfNot
  .column 21 0 24 0 0,  -- 86: Column
  .column 9 0 20 0 0,  -- 87: Column
  .ne 24 92 20 "RTRIM-8" 81,  -- 88: Ne
  .idxRowid 21 17 0 0 0,  -- 89: IdxRowid
  .rowSetTest 16 92 17 -1 0,  -- 90: RowSetTest
  .gosub 15 94 0 0 0,  -- 91: Gosub
  .next 22 73 0 0 0,  -- 92: Next
  .goto 0 107 0 0 0,  -- 93: Goto
  .column 21 0 20 0 0,  -- 94: Column
  .column 9 0 25 0 0,  -- 95: Column
  .lt 25 98 20 "RTRIM-8" 81,  -- 96: Lt
  .le 21 103 20 "RTRIM-8" 65,  -- 97: Le
  .column 21 0 20 0 0,  -- 98: Column
  .ifNot 20 106 1 0 0,  -- 99: IfNot
  .column 21 0 20 0 0,  -- 100: Column
  .column 9 0 25 0 0,  -- 101: Column
  .ne 20 106 25 "RTRIM-8" 81,  -- 102: Ne
  .column 21 0 13 0 0,  -- 103: Column
  .clrSubtype 13 0 0 0 0,  -- 104: ClrSubtype
  .decrJumpZero 14 109 0 0 0,  -- 105: DecrJumpZero
  .return 15 94 0 0 0,  -- 106: Return
  .next 9 42 0 0 1,  -- 107: Next
  .next 8 41 0 0 1,  -- 108: Next
  .return 12 33 1 0 0,  -- 109: Return
  .copy 13 11 0 0 0,  -- 110: Copy
  .isNull 11 130 0 0 0,  -- 111: IsNull
  .seekGE 20 130 11 1 0,  -- 112: SeekGE
  .null 0 11 0 0 0,  -- 113: Null
  .isNull 11 130 0 0 0,  -- 114: IsNull
  .idxGT 20 130 11 1 0,  -- 115: IdxGT
  .deferredSeek 20 0 3 "[1,0]" 0,  -- 116: DeferredSeek
  .column 20 0 26 0 0,  -- 117: Column
  .column 5 0 27 0 0,  -- 118: Column
  .lt 27 121 26 "BINARY-8" 81,  -- 119: Lt
  .le 21 126 26 "BINARY-8" 65,  -- 120: Le
  .column 20 0 26 0 0,  -- 121: Column
  .ifNot 26 129 1 0 0,  -- 122: IfNot
  .column 20 0 26 0 0,  -- 123: Column
  .column 5 0 27 0 0,  -- 124: Column
  .ne 26 129 27 "BINARY-8" 81,  -- 125: Ne
  .idxRowid 20 10 0 0 0,  -- 126: IdxRowid
  .rowSetTest 9 129 10 0 0,  -- 127: RowSetTest
  .gosub 8 368 0 0 0,  -- 128: Gosub
  .next 20 115 0 0 0,  -- 129: Next
  .reopenIdx 20 5 0 "k(2,,)" 2,  -- 130: ReopenIdx
  .noop 0 29 0 0 0,  -- 131: Noop
  .noop 0 0 0 0 0,  -- 132: Noop
  .openEphemeral 23 1 0 "k(1,B)" 0,  -- 133: OpenEphemeral
  .column 4 0 27 0 0,  -- 134: Column
  .makeRecord 27 1 30 "A" 0,  -- 135: MakeRecord
  .idxInsert 23 30 27 1 0,  -- 136: IdxInsert
  .rewind 23 367 0 0 0,  -- 137: Rewind
  .column 23 0 28 0 0,  -- 138: Column
  .isNull 28 366 0 0 0,  -- 139: IsNull
  .seekGE 20 366 28 1 0,  -- 140: SeekGE
  .idxGT 20 366 28 1 0,  -- 141: IdxGT
  .deferredSeek 20 0 3 "[1,0]" 0,  -- 142: DeferredSeek
  .column 20 0 30 0 0,  -- 143: Column
  .column 5 0 27 0 0,  -- 144: Column
  .lt 27 147 30 "BINARY-8" 81,  -- 145: Lt
  .le 21 152 30 "BINARY-8" 65,  -- 146: Le
  .column 20 0 30 0 0,  -- 147: Column
  .ifNot 30 366 1 0 0,  -- 148: IfNot
  .column 20 0 30 0 0,  -- 149: Column
  .column 5 0 27 0 0,  -- 150: Column
  .ne 30 366 27 "BINARY-8" 81,  -- 151: Ne
  .beginSubrtn 0 31 0 0 0,  -- 152: BeginSubrtn
  .once 0 361 0 0 0,  -- 153: Once
  .integer 0 32 0 0 0,  -- 154: Integer
  .integer 1 33 0 0 0,  -- 155: Integer
  .openRead 10 3 0 1 0,  -- 156: OpenRead
  .openRead 11 4 0 1 0,  -- 157: OpenRead
  .rewind 10 361 0 0 0,  -- 158: Rewind
  .null 0 35 0 0 0,  -- 159: Null
  .integer 356 34 0 0 0,  -- 160: Integer
  .reopenIdx 24 5 0 "k(2,,)" 0,  -- 161: ReopenIdx
  .column 10 0 37 0 0,  -- 162: Column
  .isNull 37 173 0 0 0,  -- 163: IsNull
  .seekGE 24 173 37 1 0,  -- 164: SeekGE
  .null 0 37 0 0 0,  -- 165: Null
  .isNull 37 173 0 0 0,  -- 166: IsNull
  .idxGT 24 173 37 1 0,  -- 167: IdxGT
  .deferredSeek 24 0 11 "[1,0]" 0,  -- 168: DeferredSeek
  .idxRowid 24 36 0 0 0,  -- 169: IdxRowid
  .rowSetTest 35 172 36 0 0,  -- 170: RowSetTest
  .gosub 34 357 0 0 0,  -- 171: Gosub
  .next 24 167 0 0 0,  -- 172: Next
  .reopenIdx 24 5 0 "k(2,,)" 2,  -- 173: ReopenIdx
  .beginSubrtn 0 39 0 "subrtnsig:6,A" 0,  -- 174: BeginSubrtn
  .once 0 343 40 0 0,  -- 175: Once
  .openEphemeral 25 1 0 "k(1,B)" 0,  -- 176: OpenEphemeral
  .blob 10000 40 0 0 0,  -- 177: Blob
  .openRead 14 3 0 1 0,  -- 178: OpenRead
  .openRead 15 3 0 1 0,  -- 179: OpenRead
  .openRead 13 4 0 1 0,  -- 180: OpenRead
  .ifEmpty 13 342 0 0 0,  -- 181: IfEmpty
  .rewind 14 342 0 0 0,  -- 182: Rewind
  .rewind 15 342 0 0 0,  -- 183: Rewind
  .null 0 42 0 0 0,  -- 184: Null
  .integer 280 41 0 0 0,  -- 185: Integer
  .reopenIdx 26 5 0 "k(2,,)" 0,  -- 186: ReopenIdx
  .column 15 0 44 0 0,  -- 187: Column
  .isNull 44 252 0 0 0,  -- 188: IsNull
  .seekGE 26 252 44 1 0,  -- 189: SeekGE
  .null 0 44 0 0 0,  -- 190: Null
  .isNull 44 252 0 0 0,  -- 191: IsNull
  .idxGT 26 252 44 1 0,  -- 192: IdxGT
  .deferredSeek 26 0 13 "[1,0]" 0,  -- 193: DeferredSeek
  .column 26 0 45 0 0,  -- 194: Column
  .beginSubrtn 0 47 0 0 0,  -- 195: BeginSubrtn
  .null 0 48 48 0 0,  -- 196: Null
  .initCoroutine 49 222 198 0 0,  -- 197: InitCoroutine
  .column 26 0 52 0 0,  -- 198: Column
  .column 14 0 54 0 0,  -- 199: Column
  .integer 1 53 0 0 0,  -- 200: Integer
  .ge 54 203 52 "BINARY-8" 65,  -- 201: Ge
  .zeroOrNull 52 53 54 0 0,  -- 202: ZeroOrNull
  .integer 1 54 0 0 0,  -- 203: Integer
  .le 21 206 52 "BINARY-8" 65,  -- 204: Le
  .zeroOrNull 52 54 21 0 0,  -- 205: ZeroOrNull
  .and 54 53 51 0 0,  -- 206: And
  .column 26 0 54 0 0,  -- 207: Column
  .null 0 53 0 0 0,  -- 208: Null
  .column 26 0 55 0 0,  -- 209: Column
  .bitAnd 55 55 56 0 0,  -- 210: BitAnd
  .column 14 0 57 0 0,  -- 211: Column
  .bitAnd 56 57 56 0 0,  -- 212: BitAnd
  .eq 55 216 57 "BINARY-8" 65,  -- 213: Eq
  .isNull 56 218 0 0 0,  -- 214: IsNull
  .goto 0 217 0 0 0,  -- 215: Goto
  .integer 1 53 0 0 0,  -- 216: Integer
  .addImm 53 0 0 0 0,  -- 217: AddImm
  .and 53 54 52 0 0,  -- 218: And
  .or 52 51 50 0 0,  -- 219: Or
  .yield 49 0 0 0 0,  -- 220: Yield
  .endCoroutine 49 0 0 0 0,  -- 221: EndCoroutine
  .integer 1 58 0 0 0,  -- 222: Integer
  .openRead 17 3 0 1 0,  -- 223: OpenRead
  .initCoroutine 49 0 198 0 0,  -- 224: InitCoroutine
  .yield 49 240 0 0 0,  -- 225: Yield
  .rewind 17 240 0 0 0,  -- 226: Rewind
  .column 26 0 59 0 0,  -- 227: Column
  .column 17 0 60 0 0,  -- 228: Column
  .lt 60 231 59 "BINARY-8" 81,  -- 229: Lt
  .le 21 236 59 "BINARY-8" 65,  -- 230: Le
  .column 26 0 59 0 0,  -- 231: Column
  .ifNot 59 238 1 0 0,  -- 232: IfNot
  .column 26 0 59 0 0,  -- 233: Column
  .column 17 0 60 0 0,  -- 234: Column
  .ne 59 238 60 "BINARY-8" 81,  -- 235: Ne
  .column 26 0 48 0 0,  -- 236: Column
  .decrJumpZero 58 240 0 0 0,  -- 237: DecrJumpZero
  .next 17 227 0 0 1,  -- 238: Next
  .goto 0 225 0 0 0,  -- 239: Goto
  .return 47 196 1 0 0,  -- 240: Return
  .lt 48 243 45 "BINARY-8" 81,  -- 241: Lt
  .le 21 248 45 "BINARY-8" 65,  -- 242: Le
  .column 26 0 45 0 0,  -- 243: Column
  .ifNot 45 251 1 0 0,  -- 244: IfNot
  .column 26 0 45 0 0,  -- 245: Column
  .column 14 0 46 0 0,  -- 246: Column
  .ne 45 251 46 "BINARY-8" 81,  -- 247: Ne
  .idxRowid 26 43 0 0 0,  -- 248: IdxRowid
  .rowSetTest 42 251 43 0 0,  -- 249: RowSetTest
  .gosub 41 281 0 0 0,  -- 250: Gosub
  .next 26 192 0 0 0,  -- 251: Next
  .reopenIdx 26 5 0 "k(2,,)" 2,  -- 252: ReopenIdx
  .noop 0 62 0 0 0,  -- 253: Noop
  .noop 0 0 0 0 0,  -- 254: Noop
  .openEphemeral 27 1 0 "k(1,B)" 0,  -- 255: OpenEphemeral
  .column 15 0 46 0 0,  -- 256: Column
  .makeRecord 46 1 63 "A" 0,  -- 257: MakeRecord
  .idxInsert 27 63 46 1 0,  -- 258: IdxInsert
  .rewind 27 280 0 0 0,  -- 259: Rewind
  .column 27 0 61 0 0,  -- 260: Column
  .isNull 61 279 0 0 0,  -- 261: IsNull
  .seekGE 26 279 61 1 0,  -- 262: SeekGE
  .idxGT 26 279 61 1 0,  -- 263: IdxGT
  .deferredSeek 26 0 13 "[1,0]" 0,  -- 264: DeferredSeek
  .column 26 0 63 0 0,  -- 265: Column
  .ifNot 63 279 1 0 0,  -- 266: IfNot
  .column 26 0 63 0 0,  -- 267: Column
  .gosub 47 196 0 0 0,  -- 268: Gosub
  .lt 48 271 63 "BINARY-8" 81,  -- 269: Lt
  .le 21 276 63 "BINARY-8" 65,  -- 270: Le
  .column 26 0 63 0 0,  -- 271: Column
  .ifNot 63 279 1 0 0,  -- 272: IfNot
  .column 26 0 63 0 0,  -- 273: Column
  .column 14 0 46 0 0,  -- 274: Column
  .ne 63 279 46 "BINARY-8" 81,  -- 275: Ne
  .idxRowid 26 43 0 0 0,  -- 276: IdxRowid
  .rowSetTest 42 279 43 -1 0,  -- 277: RowSetTest
  .gosub 41 281 0 0 0,  -- 278: Gosub
  .next 27 260 0 0 0,  -- 279: Next
  .goto 0 340 0 0 0,  -- 280: Goto
  .column 26 0 46 0 0,  -- 281: Column
  .beginSubrtn 0 65 0 0 0,  -- 282: BeginSubrtn
  .null 0 66 66 0 0,  -- 283: Null
  .initCoroutine 67 309 285 0 0,  -- 284: InitCoroutine
  .column 26 0 70 0 0,  -- 285: Column
  .column 14 0 72 0 0,  -- 286: Column
  .integer 1 71 0 0 0,  -- 287: Integer
  .ge 72 290 70 "BINARY-8" 65,  -- 288: Ge
  .zeroOrNull 70 71 72 0 0,  -- 289: ZeroOrNull
  .integer 1 72 0 0 0,  -- 290: Integer
  .le 21 293 70 "BINARY-8" 65,  -- 291: Le
  .zeroOrNull 70 72 21 0 0,  -- 292: ZeroOrNull
  .and 72 71 69 0 0,  -- 293: And
  .column 26 0 72 0 0,  -- 294: Column
  .null 0 71 0 0 0,  -- 295: Null
  .column 26 0 73 0 0,  -- 296: Column
  .bitAnd 73 73 74 0 0,  -- 297: BitAnd
  .column 14 0 75 0 0,  -- 298: Column
  .bitAnd 74 75 74 0 0,  -- 299: BitAnd
  .eq 73 303 75 "BINARY-8" 65,  -- 300: Eq
  .isNull 74 305 0 0 0,  -- 301: IsNull
  .goto 0 304 0 0 0,  -- 302: Goto
  .integer 1 71 0 0 0,  -- 303: Integer
  .addImm 71 0 0 0 0,  -- 304: AddImm
  .and 71 72 70 0 0,  -- 305: And
  .or 70 69 68 0 0,  -- 306: Or
  .yield 67 0 0 0 0,  -- 307: Yield
  .endCoroutine 67 0 0 0 0,  -- 308: EndCoroutine
  .integer 1 76 0 0 0,  -- 309: Integer
  .openRead 17 3 0 1 0,  -- 310: OpenRead
  .initCoroutine 67 0 285 0 0,  -- 311: InitCoroutine
  .yield 67 327 0 0 0,  -- 312: Yield
  .rewind 17 327 0 0 0,  -- 313: Rewind
  .column 26 0 77 0 0,  -- 314: Column
  .column 17 0 78 0 0,  -- 315: Column
  .lt 78 318 77 "BINARY-8" 81,  -- 316: Lt
  .le 21 323 77 "BINARY-8" 65,  -- 317: Le
  .column 26 0 77 0 0,  -- 318: Column
  .ifNot 77 325 1 0 0,  -- 319: IfNot
  .column 26 0 77 0 0,  -- 320: Column
  .column 17 0 78 0 0,  -- 321: Column
  .ne 77 325 78 "BINARY-8" 81,  -- 322: Ne
  .column 26 0 66 0 0,  -- 323: Column
  .decrJumpZero 76 327 0 0 0,  -- 324: DecrJumpZero
  .next 17 314 0 0 1,  -- 325: Next
  .goto 0 312 0 0 0,  -- 326: Goto
  .return 65 283 1 0 0,  -- 327: Return
  .lt 66 330 46 "BINARY-8" 81,  -- 328: Lt
  .le 21 335 46 "BINARY-8" 65,  -- 329: Le
  .column 26 0 46 0 0,  -- 330: Column
  .ifNot 46 339 1 0 0,  -- 331: IfNot
  .column 26 0 46 0 0,  -- 332: Column
  .column 14 0 64 0 0,  -- 333: Column
  .ne 46 339 64 "BINARY-8" 81,  -- 334: Ne
  .column 26 0 79 0 0,  -- 335: Column
  .makeRecord 79 1 64 "A" 0,  -- 336: MakeRecord
  .idxInsert 25 64 79 1 0,  -- 337: IdxInsert
  .filterAdd 40 0 79 1 0,  -- 338: FilterAdd
  .return 41 281 0 0 0,  -- 339: Return
  .next 15 184 0 0 1,  -- 340: Next
  .next 14 183 0 0 1,  -- 341: Next
  .nullRow 25 0 0 0 0,  -- 342: NullRow
  .return 39 175 1 0 0,  -- 343: Return
  .rewind 25 356 0 0 0,  -- 344: Rewind
  .column 25 0 38 0 0,  -- 345: Column
  .isNull 38 355 0 0 0,  -- 346: IsNull
  .seekGE 24 355 38 1 0,  -- 347: SeekGE
  .idxGT 24 355 38 1 0,  -- 348: IdxGT
  .deferredSeek 24 0 11 "[1,0]" 0,  -- 349: DeferredSeek
  .column 24 0 80 0 0,  -- 350: Column
  .ifNot 80 355 1 0 0,  -- 351: IfNot
  .idxRowid 24 36 0 0 0,  -- 352: IdxRowid
  .rowSetTest 35 355 36 -1 0,  -- 353: RowSetTest
  .gosub 34 357 0 0 0,  -- 354: Gosub
  .next 25 345 0 0 0,  -- 355: Next
  .goto 0 360 0 0 0,  -- 356: Goto
  .integer 1 32 0 0 0,  -- 357: Integer
  .decrJumpZero 33 361 0 0 0,  -- 358: DecrJumpZero
  .return 34 357 0 0 0,  -- 359: Return
  .next 10 159 0 0 1,  -- 360: Next
  .return 31 153 1 0 0,  -- 361: Return
  .if 32 366 1 0 0,  -- 362: If
  .idxRowid 20 10 0 0 0,  -- 363: IdxRowid
  .rowSetTest 9 366 10 -1 0,  -- 364: RowSetTest
  .gosub 8 368 0 0 0,  -- 365: Gosub
  .next 23 138 0 0 0,  -- 366: Next
  .goto 0 382 0 0 0,  -- 367: Goto
  .column 20 0 27 0 0,  -- 368: Column
  .column 5 0 82 0 0,  -- 369: Column
  .lt 82 372 27 "BINARY-8" 81,  -- 370: Lt
  .le 21 377 27 "BINARY-8" 65,  -- 371: Le
  .column 20 0 27 0 0,  -- 372: Column
  .ifNot 27 381 1 0 0,  -- 373: IfNot
  .column 20 0 27 0 0,  -- 374: Column
  .column 5 0 82 0 0,  -- 375: Column
  .ne 27 381 82 "BINARY-8" 81,  -- 376: Ne
  .column 20 0 83 0 0,  -- 377: Column
  .makeRecord 83 1 82 "A" 0,  -- 378: MakeRecord
  .idxInsert 19 82 83 1 0,  -- 379: IdxInsert
  .filterAdd 7 0 83 1 0,  -- 380: FilterAdd
  .return 8 368 0 0 0,  -- 381: Return
  .next 5 29 0 0 1,  -- 382: Next
  .next 4 28 0 0 1,  -- 383: Next
  .nullRow 19 0 0 0 0,  -- 384: NullRow
  .return 6 20 1 0 0,  -- 385: Return
  .rewind 19 398 0 0 0,  -- 386: Rewind
  .column 19 0 5 0 0,  -- 387: Column
  .isNull 5 397 0 0 0,  -- 388: IsNull
  .seekGE 18 397 5 1 0,  -- 389: SeekGE
  .idxGT 18 397 5 1 0,  -- 390: IdxGT
  .deferredSeek 18 0 0 "[1,0]" 0,  -- 391: DeferredSeek
  .column 18 0 84 0 0,  -- 392: Column
  .ifNot 84 397 1 0 0,  -- 393: IfNot
  .idxRowid 18 3 0 0 0,  -- 394: IdxRowid
  .rowSetTest 2 397 3 -1 0,  -- 395: RowSetTest
  .gosub 1 399 0 0 0,  -- 396: Gosub
  .next 19 387 0 0 0,  -- 397: Next
  .goto 0 402 0 0 0,  -- 398: Goto
  .column 18 0 85 0 0,  -- 399: Column
  .resultRow 85 1 0 0 0,  -- 400: ResultRow
  .return 1 399 0 0 0,  -- 401: Return
  .next 1 4 0 0 1,  -- 402: Next
  .halt 0 0 0 0 0,  -- 403: Halt
  .transaction 0 0 29 1 1,  -- 404: Transaction
  .null 0 21 0 0 0,  -- 405: Null
  .goto 0 1 0 0 0  -- 406: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000146

import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000146

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
  vdbeInit 0 404 0 "" 0,  -- 0: Init
  vdbeOpenRead 1 3 0 "1" 0,  -- 1: OpenRead
  vdbeOpenRead 0 4 0 "1" 0,  -- 2: OpenRead
  vdbeRewind 1 403 0 "" 0,  -- 3: Rewind
  vdbeNull 0 2 0 "" 0,  -- 4: Null
  vdbeInteger 398 1 0 "" 0,  -- 5: Integer
  vdbeReopenIdx 18 5 0 "k(2,,)" 0,  -- 6: ReopenIdx
  vdbeColumn 1 0 4 "" 0,  -- 7: Column
  vdbeIsNull 4 18 0 "" 0,  -- 8: IsNull
  vdbeSeekGE 18 18 4 "1" 0,  -- 9: SeekGE
  vdbeNull 0 4 0 "" 0,  -- 10: Null
  vdbeIsNull 4 18 0 "" 0,  -- 11: IsNull
  vdbeIdxGT 18 18 4 "1" 0,  -- 12: IdxGT
  vdbeDeferredSeek 18 0 0 "[1,0]" 0,  -- 13: DeferredSeek
  vdbeIdxRowid 18 3 0 "" 0,  -- 14: IdxRowid
  vdbeRowSetTest 2 17 3 "0" 0,  -- 15: RowSetTest
  vdbeGosub 1 399 0 "" 0,  -- 16: Gosub
  vdbeNext 18 12 0 "" 0,  -- 17: Next
  vdbeReopenIdx 18 5 0 "k(2,,)" 2,  -- 18: ReopenIdx
  vdbeBeginSubrtn 0 6 0 "subrtnsig:9,A" 0,  -- 19: BeginSubrtn
  vdbeOnce 0 385 7 "" 0,  -- 20: Once
  vdbeOpenEphemeral 19 1 0 "k(1,B)" 0,  -- 21: OpenEphemeral
  vdbeBlob 10000 7 0 "" 0,  -- 22: Blob
  vdbeOpenRead 4 3 0 "1" 0,  -- 23: OpenRead
  vdbeOpenRead 5 3 0 "1" 0,  -- 24: OpenRead
  vdbeOpenRead 3 4 0 "1" 0,  -- 25: OpenRead
  vdbeIfEmpty 3 384 0 "" 0,  -- 26: IfEmpty
  vdbeRewind 4 384 0 "" 0,  -- 27: Rewind
  vdbeRewind 5 384 0 "" 0,  -- 28: Rewind
  vdbeNull 0 9 0 "" 0,  -- 29: Null
  vdbeInteger 367 8 0 "" 0,  -- 30: Integer
  vdbeReopenIdx 20 5 0 "k(2,,)" 0,  -- 31: ReopenIdx
  vdbeBeginSubrtn 0 12 0 "" 0,  -- 32: BeginSubrtn
  vdbeOnce 0 109 0 "" 0,  -- 33: Once
  vdbeNull 0 13 13 "" 0,  -- 34: Null
  vdbeInteger 1 14 0 "" 0,  -- 35: Integer
  vdbeOpenRead 8 3 0 "1" 0,  -- 36: OpenRead
  vdbeOpenRead 9 3 0 "1" 0,  -- 37: OpenRead
  vdbeOpenRead 7 4 0 "1" 0,  -- 38: OpenRead
  vdbeIfEmpty 7 109 0 "" 0,  -- 39: IfEmpty
  vdbeRewind 8 109 0 "" 0,  -- 40: Rewind
  vdbeRewind 9 109 0 "" 0,  -- 41: Rewind
  vdbeNull 0 16 0 "" 0,  -- 42: Null
  vdbeInteger 93 15 0 "" 0,  -- 43: Integer
  vdbeReopenIdx 21 5 0 "k(2,,)" 0,  -- 44: ReopenIdx
  vdbeColumn 8 0 18 "" 0,  -- 45: Column
  vdbeIsNull 18 65 0 "" 0,  -- 46: IsNull
  vdbeSeekGE 21 65 18 "1" 0,  -- 47: SeekGE
  vdbeNull 0 18 0 "" 0,  -- 48: Null
  vdbeIsNull 18 65 0 "" 0,  -- 49: IsNull
  vdbeIdxGT 21 65 18 "1" 0,  -- 50: IdxGT
  vdbeDeferredSeek 21 0 7 "[1,0]" 0,  -- 51: DeferredSeek
  vdbeColumn 21 0 19 "" 0,  -- 52: Column
  vdbeColumn 9 0 20 "" 0,  -- 53: Column
  vdbeLt 20 56 19 "RTRIM-8" 81,  -- 54: Lt
  vdbeLe 21 61 19 "RTRIM-8" 65,  -- 55: Le
  vdbeColumn 21 0 19 "" 0,  -- 56: Column
  vdbeIfNot 19 64 1 "" 0,  -- 57: IfNot
  vdbeColumn 21 0 19 "" 0,  -- 58: Column
  vdbeColumn 9 0 20 "" 0,  -- 59: Column
  vdbeNe 19 64 20 "RTRIM-8" 81,  -- 60: Ne
  vdbeIdxRowid 21 17 0 "" 0,  -- 61: IdxRowid
  vdbeRowSetTest 16 64 17 "0" 0,  -- 62: RowSetTest
  vdbeGosub 15 94 0 "" 0,  -- 63: Gosub
  vdbeNext 21 50 0 "" 0,  -- 64: Next
  vdbeReopenIdx 21 5 0 "k(2,,)" 2,  -- 65: ReopenIdx
  vdbeNoop 0 23 0 "" 0,  -- 66: Noop
  vdbeNoop 0 0 0 "" 0,  -- 67: Noop
  vdbeOpenEphemeral 22 1 0 "k(1,B)" 0,  -- 68: OpenEphemeral
  vdbeColumn 8 0 20 "" 0,  -- 69: Column
  vdbeMakeRecord 20 1 24 "A" 0,  -- 70: MakeRecord
  vdbeIdxInsert 22 24 20 "1" 0,  -- 71: IdxInsert
  vdbeRewind 22 93 0 "" 0,  -- 72: Rewind
  vdbeColumn 22 0 22 "" 0,  -- 73: Column
  vdbeIsNull 22 92 0 "" 0,  -- 74: IsNull
  vdbeSeekGE 21 92 22 "1" 0,  -- 75: SeekGE
  vdbeIdxGT 21 92 22 "1" 0,  -- 76: IdxGT
  vdbeDeferredSeek 21 0 7 "[1,0]" 0,  -- 77: DeferredSeek
  vdbeColumn 21 0 24 "" 0,  -- 78: Column
  vdbeIfNot 24 92 1 "" 0,  -- 79: IfNot
  vdbeColumn 21 0 24 "" 0,  -- 80: Column
  vdbeColumn 9 0 20 "" 0,  -- 81: Column
  vdbeLt 20 84 24 "RTRIM-8" 81,  -- 82: Lt
  vdbeLe 21 89 24 "RTRIM-8" 65,  -- 83: Le
  vdbeColumn 21 0 24 "" 0,  -- 84: Column
  vdbeIfNot 24 92 1 "" 0,  -- 85: IfNot
  vdbeColumn 21 0 24 "" 0,  -- 86: Column
  vdbeColumn 9 0 20 "" 0,  -- 87: Column
  vdbeNe 24 92 20 "RTRIM-8" 81,  -- 88: Ne
  vdbeIdxRowid 21 17 0 "" 0,  -- 89: IdxRowid
  vdbeRowSetTest 16 92 17 "-1" 0,  -- 90: RowSetTest
  vdbeGosub 15 94 0 "" 0,  -- 91: Gosub
  vdbeNext 22 73 0 "" 0,  -- 92: Next
  vdbeGoto 0 107 0 "" 0,  -- 93: Goto
  vdbeColumn 21 0 20 "" 0,  -- 94: Column
  vdbeColumn 9 0 25 "" 0,  -- 95: Column
  vdbeLt 25 98 20 "RTRIM-8" 81,  -- 96: Lt
  vdbeLe 21 103 20 "RTRIM-8" 65,  -- 97: Le
  vdbeColumn 21 0 20 "" 0,  -- 98: Column
  vdbeIfNot 20 106 1 "" 0,  -- 99: IfNot
  vdbeColumn 21 0 20 "" 0,  -- 100: Column
  vdbeColumn 9 0 25 "" 0,  -- 101: Column
  vdbeNe 20 106 25 "RTRIM-8" 81,  -- 102: Ne
  vdbeColumn 21 0 13 "" 0,  -- 103: Column
  vdbeClrSubtype 13 0 0 "" 0,  -- 104: ClrSubtype
  vdbeDecrJumpZero 14 109 0 "" 0,  -- 105: DecrJumpZero
  vdbeReturn 15 94 0 "" 0,  -- 106: Return
  vdbeNext 9 42 0 "" 1,  -- 107: Next
  vdbeNext 8 41 0 "" 1,  -- 108: Next
  vdbeReturn 12 33 1 "" 0,  -- 109: Return
  vdbeCopy 13 11 0 "" 0,  -- 110: Copy
  vdbeIsNull 11 130 0 "" 0,  -- 111: IsNull
  vdbeSeekGE 20 130 11 "1" 0,  -- 112: SeekGE
  vdbeNull 0 11 0 "" 0,  -- 113: Null
  vdbeIsNull 11 130 0 "" 0,  -- 114: IsNull
  vdbeIdxGT 20 130 11 "1" 0,  -- 115: IdxGT
  vdbeDeferredSeek 20 0 3 "[1,0]" 0,  -- 116: DeferredSeek
  vdbeColumn 20 0 26 "" 0,  -- 117: Column
  vdbeColumn 5 0 27 "" 0,  -- 118: Column
  vdbeLt 27 121 26 "BINARY-8" 81,  -- 119: Lt
  vdbeLe 21 126 26 "BINARY-8" 65,  -- 120: Le
  vdbeColumn 20 0 26 "" 0,  -- 121: Column
  vdbeIfNot 26 129 1 "" 0,  -- 122: IfNot
  vdbeColumn 20 0 26 "" 0,  -- 123: Column
  vdbeColumn 5 0 27 "" 0,  -- 124: Column
  vdbeNe 26 129 27 "BINARY-8" 81,  -- 125: Ne
  vdbeIdxRowid 20 10 0 "" 0,  -- 126: IdxRowid
  vdbeRowSetTest 9 129 10 "0" 0,  -- 127: RowSetTest
  vdbeGosub 8 368 0 "" 0,  -- 128: Gosub
  vdbeNext 20 115 0 "" 0,  -- 129: Next
  vdbeReopenIdx 20 5 0 "k(2,,)" 2,  -- 130: ReopenIdx
  vdbeNoop 0 29 0 "" 0,  -- 131: Noop
  vdbeNoop 0 0 0 "" 0,  -- 132: Noop
  vdbeOpenEphemeral 23 1 0 "k(1,B)" 0,  -- 133: OpenEphemeral
  vdbeColumn 4 0 27 "" 0,  -- 134: Column
  vdbeMakeRecord 27 1 30 "A" 0,  -- 135: MakeRecord
  vdbeIdxInsert 23 30 27 "1" 0,  -- 136: IdxInsert
  vdbeRewind 23 367 0 "" 0,  -- 137: Rewind
  vdbeColumn 23 0 28 "" 0,  -- 138: Column
  vdbeIsNull 28 366 0 "" 0,  -- 139: IsNull
  vdbeSeekGE 20 366 28 "1" 0,  -- 140: SeekGE
  vdbeIdxGT 20 366 28 "1" 0,  -- 141: IdxGT
  vdbeDeferredSeek 20 0 3 "[1,0]" 0,  -- 142: DeferredSeek
  vdbeColumn 20 0 30 "" 0,  -- 143: Column
  vdbeColumn 5 0 27 "" 0,  -- 144: Column
  vdbeLt 27 147 30 "BINARY-8" 81,  -- 145: Lt
  vdbeLe 21 152 30 "BINARY-8" 65,  -- 146: Le
  vdbeColumn 20 0 30 "" 0,  -- 147: Column
  vdbeIfNot 30 366 1 "" 0,  -- 148: IfNot
  vdbeColumn 20 0 30 "" 0,  -- 149: Column
  vdbeColumn 5 0 27 "" 0,  -- 150: Column
  vdbeNe 30 366 27 "BINARY-8" 81,  -- 151: Ne
  vdbeBeginSubrtn 0 31 0 "" 0,  -- 152: BeginSubrtn
  vdbeOnce 0 361 0 "" 0,  -- 153: Once
  vdbeInteger 0 32 0 "" 0,  -- 154: Integer
  vdbeInteger 1 33 0 "" 0,  -- 155: Integer
  vdbeOpenRead 10 3 0 "1" 0,  -- 156: OpenRead
  vdbeOpenRead 11 4 0 "1" 0,  -- 157: OpenRead
  vdbeRewind 10 361 0 "" 0,  -- 158: Rewind
  vdbeNull 0 35 0 "" 0,  -- 159: Null
  vdbeInteger 356 34 0 "" 0,  -- 160: Integer
  vdbeReopenIdx 24 5 0 "k(2,,)" 0,  -- 161: ReopenIdx
  vdbeColumn 10 0 37 "" 0,  -- 162: Column
  vdbeIsNull 37 173 0 "" 0,  -- 163: IsNull
  vdbeSeekGE 24 173 37 "1" 0,  -- 164: SeekGE
  vdbeNull 0 37 0 "" 0,  -- 165: Null
  vdbeIsNull 37 173 0 "" 0,  -- 166: IsNull
  vdbeIdxGT 24 173 37 "1" 0,  -- 167: IdxGT
  vdbeDeferredSeek 24 0 11 "[1,0]" 0,  -- 168: DeferredSeek
  vdbeIdxRowid 24 36 0 "" 0,  -- 169: IdxRowid
  vdbeRowSetTest 35 172 36 "0" 0,  -- 170: RowSetTest
  vdbeGosub 34 357 0 "" 0,  -- 171: Gosub
  vdbeNext 24 167 0 "" 0,  -- 172: Next
  vdbeReopenIdx 24 5 0 "k(2,,)" 2,  -- 173: ReopenIdx
  vdbeBeginSubrtn 0 39 0 "subrtnsig:6,A" 0,  -- 174: BeginSubrtn
  vdbeOnce 0 343 40 "" 0,  -- 175: Once
  vdbeOpenEphemeral 25 1 0 "k(1,B)" 0,  -- 176: OpenEphemeral
  vdbeBlob 10000 40 0 "" 0,  -- 177: Blob
  vdbeOpenRead 14 3 0 "1" 0,  -- 178: OpenRead
  vdbeOpenRead 15 3 0 "1" 0,  -- 179: OpenRead
  vdbeOpenRead 13 4 0 "1" 0,  -- 180: OpenRead
  vdbeIfEmpty 13 342 0 "" 0,  -- 181: IfEmpty
  vdbeRewind 14 342 0 "" 0,  -- 182: Rewind
  vdbeRewind 15 342 0 "" 0,  -- 183: Rewind
  vdbeNull 0 42 0 "" 0,  -- 184: Null
  vdbeInteger 280 41 0 "" 0,  -- 185: Integer
  vdbeReopenIdx 26 5 0 "k(2,,)" 0,  -- 186: ReopenIdx
  vdbeColumn 15 0 44 "" 0,  -- 187: Column
  vdbeIsNull 44 252 0 "" 0,  -- 188: IsNull
  vdbeSeekGE 26 252 44 "1" 0,  -- 189: SeekGE
  vdbeNull 0 44 0 "" 0,  -- 190: Null
  vdbeIsNull 44 252 0 "" 0,  -- 191: IsNull
  vdbeIdxGT 26 252 44 "1" 0,  -- 192: IdxGT
  vdbeDeferredSeek 26 0 13 "[1,0]" 0,  -- 193: DeferredSeek
  vdbeColumn 26 0 45 "" 0,  -- 194: Column
  vdbeBeginSubrtn 0 47 0 "" 0,  -- 195: BeginSubrtn
  vdbeNull 0 48 48 "" 0,  -- 196: Null
  vdbeInitCoroutine 49 222 198 "" 0,  -- 197: InitCoroutine
  vdbeColumn 26 0 52 "" 0,  -- 198: Column
  vdbeColumn 14 0 54 "" 0,  -- 199: Column
  vdbeInteger 1 53 0 "" 0,  -- 200: Integer
  vdbeGe 54 203 52 "BINARY-8" 65,  -- 201: Ge
  vdbeZeroOrNull 52 53 54 "" 0,  -- 202: ZeroOrNull
  vdbeInteger 1 54 0 "" 0,  -- 203: Integer
  vdbeLe 21 206 52 "BINARY-8" 65,  -- 204: Le
  vdbeZeroOrNull 52 54 21 "" 0,  -- 205: ZeroOrNull
  vdbeAnd 54 53 51 "" 0,  -- 206: And
  vdbeColumn 26 0 54 "" 0,  -- 207: Column
  vdbeNull 0 53 0 "" 0,  -- 208: Null
  vdbeColumn 26 0 55 "" 0,  -- 209: Column
  vdbeBitAnd 55 55 56 "" 0,  -- 210: BitAnd
  vdbeColumn 14 0 57 "" 0,  -- 211: Column
  vdbeBitAnd 56 57 56 "" 0,  -- 212: BitAnd
  vdbeEq 55 216 57 "BINARY-8" 65,  -- 213: Eq
  vdbeIsNull 56 218 0 "" 0,  -- 214: IsNull
  vdbeGoto 0 217 0 "" 0,  -- 215: Goto
  vdbeInteger 1 53 0 "" 0,  -- 216: Integer
  vdbeAddImm 53 0 0 "" 0,  -- 217: AddImm
  vdbeAnd 53 54 52 "" 0,  -- 218: And
  vdbeOr 52 51 50 "" 0,  -- 219: Or
  vdbeYield 49 0 0 "" 0,  -- 220: Yield
  vdbeEndCoroutine 49 0 0 "" 0,  -- 221: EndCoroutine
  vdbeInteger 1 58 0 "" 0,  -- 222: Integer
  vdbeOpenRead 17 3 0 "1" 0,  -- 223: OpenRead
  vdbeInitCoroutine 49 0 198 "" 0,  -- 224: InitCoroutine
  vdbeYield 49 240 0 "" 0,  -- 225: Yield
  vdbeRewind 17 240 0 "" 0,  -- 226: Rewind
  vdbeColumn 26 0 59 "" 0,  -- 227: Column
  vdbeColumn 17 0 60 "" 0,  -- 228: Column
  vdbeLt 60 231 59 "BINARY-8" 81,  -- 229: Lt
  vdbeLe 21 236 59 "BINARY-8" 65,  -- 230: Le
  vdbeColumn 26 0 59 "" 0,  -- 231: Column
  vdbeIfNot 59 238 1 "" 0,  -- 232: IfNot
  vdbeColumn 26 0 59 "" 0,  -- 233: Column
  vdbeColumn 17 0 60 "" 0,  -- 234: Column
  vdbeNe 59 238 60 "BINARY-8" 81,  -- 235: Ne
  vdbeColumn 26 0 48 "" 0,  -- 236: Column
  vdbeDecrJumpZero 58 240 0 "" 0,  -- 237: DecrJumpZero
  vdbeNext 17 227 0 "" 1,  -- 238: Next
  vdbeGoto 0 225 0 "" 0,  -- 239: Goto
  vdbeReturn 47 196 1 "" 0,  -- 240: Return
  vdbeLt 48 243 45 "BINARY-8" 81,  -- 241: Lt
  vdbeLe 21 248 45 "BINARY-8" 65,  -- 242: Le
  vdbeColumn 26 0 45 "" 0,  -- 243: Column
  vdbeIfNot 45 251 1 "" 0,  -- 244: IfNot
  vdbeColumn 26 0 45 "" 0,  -- 245: Column
  vdbeColumn 14 0 46 "" 0,  -- 246: Column
  vdbeNe 45 251 46 "BINARY-8" 81,  -- 247: Ne
  vdbeIdxRowid 26 43 0 "" 0,  -- 248: IdxRowid
  vdbeRowSetTest 42 251 43 "0" 0,  -- 249: RowSetTest
  vdbeGosub 41 281 0 "" 0,  -- 250: Gosub
  vdbeNext 26 192 0 "" 0,  -- 251: Next
  vdbeReopenIdx 26 5 0 "k(2,,)" 2,  -- 252: ReopenIdx
  vdbeNoop 0 62 0 "" 0,  -- 253: Noop
  vdbeNoop 0 0 0 "" 0,  -- 254: Noop
  vdbeOpenEphemeral 27 1 0 "k(1,B)" 0,  -- 255: OpenEphemeral
  vdbeColumn 15 0 46 "" 0,  -- 256: Column
  vdbeMakeRecord 46 1 63 "A" 0,  -- 257: MakeRecord
  vdbeIdxInsert 27 63 46 "1" 0,  -- 258: IdxInsert
  vdbeRewind 27 280 0 "" 0,  -- 259: Rewind
  vdbeColumn 27 0 61 "" 0,  -- 260: Column
  vdbeIsNull 61 279 0 "" 0,  -- 261: IsNull
  vdbeSeekGE 26 279 61 "1" 0,  -- 262: SeekGE
  vdbeIdxGT 26 279 61 "1" 0,  -- 263: IdxGT
  vdbeDeferredSeek 26 0 13 "[1,0]" 0,  -- 264: DeferredSeek
  vdbeColumn 26 0 63 "" 0,  -- 265: Column
  vdbeIfNot 63 279 1 "" 0,  -- 266: IfNot
  vdbeColumn 26 0 63 "" 0,  -- 267: Column
  vdbeGosub 47 196 0 "" 0,  -- 268: Gosub
  vdbeLt 48 271 63 "BINARY-8" 81,  -- 269: Lt
  vdbeLe 21 276 63 "BINARY-8" 65,  -- 270: Le
  vdbeColumn 26 0 63 "" 0,  -- 271: Column
  vdbeIfNot 63 279 1 "" 0,  -- 272: IfNot
  vdbeColumn 26 0 63 "" 0,  -- 273: Column
  vdbeColumn 14 0 46 "" 0,  -- 274: Column
  vdbeNe 63 279 46 "BINARY-8" 81,  -- 275: Ne
  vdbeIdxRowid 26 43 0 "" 0,  -- 276: IdxRowid
  vdbeRowSetTest 42 279 43 "-1" 0,  -- 277: RowSetTest
  vdbeGosub 41 281 0 "" 0,  -- 278: Gosub
  vdbeNext 27 260 0 "" 0,  -- 279: Next
  vdbeGoto 0 340 0 "" 0,  -- 280: Goto
  vdbeColumn 26 0 46 "" 0,  -- 281: Column
  vdbeBeginSubrtn 0 65 0 "" 0,  -- 282: BeginSubrtn
  vdbeNull 0 66 66 "" 0,  -- 283: Null
  vdbeInitCoroutine 67 309 285 "" 0,  -- 284: InitCoroutine
  vdbeColumn 26 0 70 "" 0,  -- 285: Column
  vdbeColumn 14 0 72 "" 0,  -- 286: Column
  vdbeInteger 1 71 0 "" 0,  -- 287: Integer
  vdbeGe 72 290 70 "BINARY-8" 65,  -- 288: Ge
  vdbeZeroOrNull 70 71 72 "" 0,  -- 289: ZeroOrNull
  vdbeInteger 1 72 0 "" 0,  -- 290: Integer
  vdbeLe 21 293 70 "BINARY-8" 65,  -- 291: Le
  vdbeZeroOrNull 70 72 21 "" 0,  -- 292: ZeroOrNull
  vdbeAnd 72 71 69 "" 0,  -- 293: And
  vdbeColumn 26 0 72 "" 0,  -- 294: Column
  vdbeNull 0 71 0 "" 0,  -- 295: Null
  vdbeColumn 26 0 73 "" 0,  -- 296: Column
  vdbeBitAnd 73 73 74 "" 0,  -- 297: BitAnd
  vdbeColumn 14 0 75 "" 0,  -- 298: Column
  vdbeBitAnd 74 75 74 "" 0,  -- 299: BitAnd
  vdbeEq 73 303 75 "BINARY-8" 65,  -- 300: Eq
  vdbeIsNull 74 305 0 "" 0,  -- 301: IsNull
  vdbeGoto 0 304 0 "" 0,  -- 302: Goto
  vdbeInteger 1 71 0 "" 0,  -- 303: Integer
  vdbeAddImm 71 0 0 "" 0,  -- 304: AddImm
  vdbeAnd 71 72 70 "" 0,  -- 305: And
  vdbeOr 70 69 68 "" 0,  -- 306: Or
  vdbeYield 67 0 0 "" 0,  -- 307: Yield
  vdbeEndCoroutine 67 0 0 "" 0,  -- 308: EndCoroutine
  vdbeInteger 1 76 0 "" 0,  -- 309: Integer
  vdbeOpenRead 17 3 0 "1" 0,  -- 310: OpenRead
  vdbeInitCoroutine 67 0 285 "" 0,  -- 311: InitCoroutine
  vdbeYield 67 327 0 "" 0,  -- 312: Yield
  vdbeRewind 17 327 0 "" 0,  -- 313: Rewind
  vdbeColumn 26 0 77 "" 0,  -- 314: Column
  vdbeColumn 17 0 78 "" 0,  -- 315: Column
  vdbeLt 78 318 77 "BINARY-8" 81,  -- 316: Lt
  vdbeLe 21 323 77 "BINARY-8" 65,  -- 317: Le
  vdbeColumn 26 0 77 "" 0,  -- 318: Column
  vdbeIfNot 77 325 1 "" 0,  -- 319: IfNot
  vdbeColumn 26 0 77 "" 0,  -- 320: Column
  vdbeColumn 17 0 78 "" 0,  -- 321: Column
  vdbeNe 77 325 78 "BINARY-8" 81,  -- 322: Ne
  vdbeColumn 26 0 66 "" 0,  -- 323: Column
  vdbeDecrJumpZero 76 327 0 "" 0,  -- 324: DecrJumpZero
  vdbeNext 17 314 0 "" 1,  -- 325: Next
  vdbeGoto 0 312 0 "" 0,  -- 326: Goto
  vdbeReturn 65 283 1 "" 0,  -- 327: Return
  vdbeLt 66 330 46 "BINARY-8" 81,  -- 328: Lt
  vdbeLe 21 335 46 "BINARY-8" 65,  -- 329: Le
  vdbeColumn 26 0 46 "" 0,  -- 330: Column
  vdbeIfNot 46 339 1 "" 0,  -- 331: IfNot
  vdbeColumn 26 0 46 "" 0,  -- 332: Column
  vdbeColumn 14 0 64 "" 0,  -- 333: Column
  vdbeNe 46 339 64 "BINARY-8" 81,  -- 334: Ne
  vdbeColumn 26 0 79 "" 0,  -- 335: Column
  vdbeMakeRecord 79 1 64 "A" 0,  -- 336: MakeRecord
  vdbeIdxInsert 25 64 79 "1" 0,  -- 337: IdxInsert
  vdbeFilterAdd 40 0 79 "1" 0,  -- 338: FilterAdd
  vdbeReturn 41 281 0 "" 0,  -- 339: Return
  vdbeNext 15 184 0 "" 1,  -- 340: Next
  vdbeNext 14 183 0 "" 1,  -- 341: Next
  vdbeNullRow 25 0 0 "" 0,  -- 342: NullRow
  vdbeReturn 39 175 1 "" 0,  -- 343: Return
  vdbeRewind 25 356 0 "" 0,  -- 344: Rewind
  vdbeColumn 25 0 38 "" 0,  -- 345: Column
  vdbeIsNull 38 355 0 "" 0,  -- 346: IsNull
  vdbeSeekGE 24 355 38 "1" 0,  -- 347: SeekGE
  vdbeIdxGT 24 355 38 "1" 0,  -- 348: IdxGT
  vdbeDeferredSeek 24 0 11 "[1,0]" 0,  -- 349: DeferredSeek
  vdbeColumn 24 0 80 "" 0,  -- 350: Column
  vdbeIfNot 80 355 1 "" 0,  -- 351: IfNot
  vdbeIdxRowid 24 36 0 "" 0,  -- 352: IdxRowid
  vdbeRowSetTest 35 355 36 "-1" 0,  -- 353: RowSetTest
  vdbeGosub 34 357 0 "" 0,  -- 354: Gosub
  vdbeNext 25 345 0 "" 0,  -- 355: Next
  vdbeGoto 0 360 0 "" 0,  -- 356: Goto
  vdbeInteger 1 32 0 "" 0,  -- 357: Integer
  vdbeDecrJumpZero 33 361 0 "" 0,  -- 358: DecrJumpZero
  vdbeReturn 34 357 0 "" 0,  -- 359: Return
  vdbeNext 10 159 0 "" 1,  -- 360: Next
  vdbeReturn 31 153 1 "" 0,  -- 361: Return
  vdbeIf 32 366 1 "" 0,  -- 362: If
  vdbeIdxRowid 20 10 0 "" 0,  -- 363: IdxRowid
  vdbeRowSetTest 9 366 10 "-1" 0,  -- 364: RowSetTest
  vdbeGosub 8 368 0 "" 0,  -- 365: Gosub
  vdbeNext 23 138 0 "" 0,  -- 366: Next
  vdbeGoto 0 382 0 "" 0,  -- 367: Goto
  vdbeColumn 20 0 27 "" 0,  -- 368: Column
  vdbeColumn 5 0 82 "" 0,  -- 369: Column
  vdbeLt 82 372 27 "BINARY-8" 81,  -- 370: Lt
  vdbeLe 21 377 27 "BINARY-8" 65,  -- 371: Le
  vdbeColumn 20 0 27 "" 0,  -- 372: Column
  vdbeIfNot 27 381 1 "" 0,  -- 373: IfNot
  vdbeColumn 20 0 27 "" 0,  -- 374: Column
  vdbeColumn 5 0 82 "" 0,  -- 375: Column
  vdbeNe 27 381 82 "BINARY-8" 81,  -- 376: Ne
  vdbeColumn 20 0 83 "" 0,  -- 377: Column
  vdbeMakeRecord 83 1 82 "A" 0,  -- 378: MakeRecord
  vdbeIdxInsert 19 82 83 "1" 0,  -- 379: IdxInsert
  vdbeFilterAdd 7 0 83 "1" 0,  -- 380: FilterAdd
  vdbeReturn 8 368 0 "" 0,  -- 381: Return
  vdbeNext 5 29 0 "" 1,  -- 382: Next
  vdbeNext 4 28 0 "" 1,  -- 383: Next
  vdbeNullRow 19 0 0 "" 0,  -- 384: NullRow
  vdbeReturn 6 20 1 "" 0,  -- 385: Return
  vdbeRewind 19 398 0 "" 0,  -- 386: Rewind
  vdbeColumn 19 0 5 "" 0,  -- 387: Column
  vdbeIsNull 5 397 0 "" 0,  -- 388: IsNull
  vdbeSeekGE 18 397 5 "1" 0,  -- 389: SeekGE
  vdbeIdxGT 18 397 5 "1" 0,  -- 390: IdxGT
  vdbeDeferredSeek 18 0 0 "[1,0]" 0,  -- 391: DeferredSeek
  vdbeColumn 18 0 84 "" 0,  -- 392: Column
  vdbeIfNot 84 397 1 "" 0,  -- 393: IfNot
  vdbeIdxRowid 18 3 0 "" 0,  -- 394: IdxRowid
  vdbeRowSetTest 2 397 3 "-1" 0,  -- 395: RowSetTest
  vdbeGosub 1 399 0 "" 0,  -- 396: Gosub
  vdbeNext 19 387 0 "" 0,  -- 397: Next
  vdbeGoto 0 402 0 "" 0,  -- 398: Goto
  vdbeColumn 18 0 85 "" 0,  -- 399: Column
  vdbeResultRow 85 1 0 "" 0,  -- 400: ResultRow
  vdbeReturn 1 399 0 "" 0,  -- 401: Return
  vdbeNext 1 4 0 "" 1,  -- 402: Next
  vdbeHalt 0 0 0 "" 0,  -- 403: Halt
  vdbeTransaction 0 0 29 "1" 1,  -- 404: Transaction
  vdbeNull 0 21 0 "" 0,  -- 405: Null
  vdbeGoto 0 1 0 "" 0  -- 406: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000146

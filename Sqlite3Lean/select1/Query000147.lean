import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.select1.Query000147

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

  Query: SELECT x FROM t2, t1 WHERE x BETWEEN c AND (c+1) OR x AND
    x IN ((SELECT x FROM (SELECT x FROM t2, t1 
    WHERE x BETWEEN (SELECT x FROM (SELECT x COLLATE rtrim 
    FROM t2, t1 WHERE x BETWEEN c AND (c+1)
    OR x AND x IN (c)), t1 WHERE x BETWEEN c AND (c+1)
    OR x AND x IN (c)) AND (c+1)
    OR NOT EXISTS(SELECT -4.81 FROM t1, t2 WHERE x BETWEEN c AND (c+1)
    OR x AND x IN ((SELECT x FROM (SELECT x FROM t2, t1
    WHERE x BETWEEN (SELECT x FROM (SELECT x BETWEEN c AND (c+1)
    OR x AND x IN (c)), t1 WHERE x BETWEEN c AND (c+1)
    OR x AND x IN (c)) AND (c+1)
    OR x AND x IN (c)), t1 WHERE x BETWEEN c AND (c+1)
    OR x AND x IN (c)))) AND x IN (c)
    ), t1 WHERE x BETWEEN c AND (c+1)
    OR x AND x IN (c)));

  VDBE Program:
  addr  opcode         p1    p2    p3    p4             p5  comment
  ----  -------------  ----  ----  ----  -------------  --  -------------
  0     Init           0     435   0                    0   
  1     OpenRead       1     3     0     1              0   
  2     OpenRead       0     4     0     1              0   
  3     Rewind         1     434   0                    0   
  4     Null           0     2     0                    0   
  5     Integer        429   1     0                    0   
  6     ReopenIdx      18    5     0     k(2,,)         0   
  7     Column         1     0     4                    0   
  8     IsNull         4     19    0                    0   
  9     SeekGE         18    19    4     1              0   
  10    Column         1     0     5                    0   
  11    Add            6     5     4                    0   
  12    IsNull         4     19    0                    0   
  13    IdxGT          18    19    4     1              0   
  14    DeferredSeek   18    0     0     [1,0]          0   
  15    IdxRowid       18    3     0                    0   
  16    RowSetTest     2     18    3     0              0   
  17    Gosub          1     430   0                    0   
  18    Next           18    13    0                    0   
  19    ReopenIdx      18    5     0     k(2,,)         2   
  20    BeginSubrtn    0     8     0     subrtnsig:9,A  0   
  21    Once           0     416   9                    0   
  22    OpenEphemeral  19    1     0     k(1,B)         0   
  23    Blob           10000  9     0                    0   
  24    OpenRead       4     3     0     1              0   
  25    OpenRead       5     3     0     1              0   
  26    OpenRead       3     4     0     1              0   
  27    IfEmpty        3     415   0                    0   
  28    Rewind         4     415   0                    0   
  29    Rewind         5     415   0                    0   
  30    Null           0     11    0                    0   
  31    Integer        396   10    0                    0   
  32    ReopenIdx      20    5     0     k(2,,)         0   
  33    BeginSubrtn    0     14    0                    0   
  34    Once           0     117   0                    0   
  35    Null           0     15    15                   0   
  36    Integer        1     16    0                    0   
  37    OpenRead       8     3     0     1              0   
  38    OpenRead       9     3     0     1              0   
  39    OpenRead       7     4     0     1              0   
  40    IfEmpty        7     117   0                    0   
  41    Rewind         8     117   0                    0   
  42    Rewind         9     117   0                    0   
  43    Null           0     18    0                    0   
  44    Integer        99    17    0                    0   
  45    ReopenIdx      21    5     0     k(2,,)         0   
  46    Column         8     0     20                   0   
  47    IsNull         20    69    0                    0   
  48    SeekGE         21    69    20    1              0   
  49    Column         8     0     5                    0   
  50    Add            6     5     20                   0   
  51    IsNull         20    69    0                    0   
  52    IdxGT          21    69    20    1              0   
  53    DeferredSeek   21    0     7     [1,0]          0   
  54    Column         21    0     5                    0   
  55    Column         9     0     21                   0   
  56    Lt             21    60    5     RTRIM-8        81  
  57    Column         9     0     22                   0   
  58    Add            6     22    21                   0   
  59    Le             21    65    5     RTRIM-8        65  
  60    Column         21    0     5                    0   
  61    IfNot          5     68    1                    0   
  62    Column         21    0     5                    0   
  63    Column         9     0     21                   0   
  64    Ne             5     68    21    RTRIM-8        81  
  65    IdxRowid       21    19    0                    0   
  66    RowSetTest     18    68    19    0              0   
  67    Gosub          17    100   0                    0   
  68    Next           21    52    0                    0   
  69    ReopenIdx      21    5     0     k(2,,)         2   
  70    Noop           0     24    0                    0   
  71    Noop           0     0     0                    0   
  72    OpenEphemeral  22    1     0     k(1,B)         0   
  73    Column         8     0     21                   0   
  74    MakeRecord     21    1     22    A              0   
  75    IdxInsert      22    22    21    1              0   
  76    Rewind         22    99    0                    0   
  77    Column         22    0     23                   0   
  78    IsNull         23    98    0                    0   
  79    SeekGE         21    98    23    1              0   
  80    IdxGT          21    98    23    1              0   
  81    DeferredSeek   21    0     7     [1,0]          0   
  82    Column         21    0     22                   0   
  83    IfNot          22    98    1                    0   
  84    Column         21    0     22                   0   
  85    Column         9     0     21                   0   
  86    Lt             21    90    22    RTRIM-8        81  
  87    Column         9     0     25                   0   
  88    Add            6     25    21                   0   
  89    Le             21    95    22    RTRIM-8        65  
  90    Column         21    0     22                   0   
  91    IfNot          22    98    1                    0   
  92    Column         21    0     22                   0   
  93    Column         9     0     21                   0   
  94    Ne             22    98    21    RTRIM-8        81  
  95    IdxRowid       21    19    0                    0   
  96    RowSetTest     18    98    19    -1             0   
  97    Gosub          17    100   0                    0   
  98    Next           22    77    0                    0   
  99    Goto           0     115   0                    0   
  100   Column         21    0     21                   0   
  101   Column         9     0     25                   0   
  102   Lt             25    106   21    RTRIM-8        81  
  103   Column         9     0     26                   0   
  104   Add            6     26    25                   0   
  105   Le             25    111   21    RTRIM-8        65  
  106   Column         21    0     21                   0   
  107   IfNot          21    114   1                    0   
  108   Column         21    0     21                   0   
  109   Column         9     0     25                   0   
  110   Ne             21    114   25    RTRIM-8        81  
  111   Column         21    0     15                   0   
  112   ClrSubtype     15    0     0                    0   
  113   DecrJumpZero   16    117   0                    0   
  114   Return         17    100   0                    0   
  115   Next           9     43    0                    1   
  116   Next           8     42    0                    1   
  117   Return         14    34    1                    0   
  118   Copy           15    13    0                    0   
  119   IsNull         13    141   0                    0   
  120   SeekGE         20    141   13    1              0   
  121   Column         4     0     27                   0   
  122   Add            6     27    13                   0   
  123   IsNull         13    141   0                    0   
  124   IdxGT          20    141   13    1              0   
  125   DeferredSeek   20    0     3     [1,0]          0   
  126   Column         20    0     27                   0   
  127   Column         5     0     28                   0   
  128   Lt             28    132   27    BINARY-8       81  
  129   Column         5     0     29                   0   
  130   Add            6     29    28                   0   
  131   Le             28    137   27    BINARY-8       65  
  132   Column         20    0     27                   0   
  133   IfNot          27    140   1                    0   
  134   Column         20    0     27                   0   
  135   Column         5     0     28                   0   
  136   Ne             27    140   28    BINARY-8       81  
  137   IdxRowid       20    12    0                    0   
  138   RowSetTest     11    140   12    0              0   
  139   Gosub          10    397   0                    0   
  140   Next           20    124   0                    0   
  141   ReopenIdx      20    5     0     k(2,,)         2   
  142   Noop           0     31    0                    0   
  143   Noop           0     0     0                    0   
  144   OpenEphemeral  23    1     0     k(1,B)         0   
  145   Column         4     0     28                   0   
  146   MakeRecord     28    1     29    A              0   
  147   IdxInsert      23    29    28    1              0   
  148   Rewind         23    396   0                    0   
  149   Column         23    0     30                   0   
  150   IsNull         30    395   0                    0   
  151   SeekGE         20    395   30    1              0   
  152   IdxGT          20    395   30    1              0   
  153   DeferredSeek   20    0     3     [1,0]          0   
  154   Column         20    0     29                   0   
  155   Column         5     0     28                   0   
  156   Lt             28    160   29    BINARY-8       81  
  157   Column         5     0     32                   0   
  158   Add            6     32    28                   0   
  159   Le             28    165   29    BINARY-8       65  
  160   Column         20    0     29                   0   
  161   IfNot          29    395   1                    0   
  162   Column         20    0     29                   0   
  163   Column         5     0     28                   0   
  164   Ne             29    395   28    BINARY-8       81  
  165   BeginSubrtn    0     33    0                    0   
  166   Once           0     390   0                    0   
  167   Integer        0     34    0                    0   
  168   Integer        1     35    0                    0   
  169   OpenRead       10    3     0     1              0   
  170   OpenRead       11    4     0     1              0   
  171   Rewind         10    390   0                    0   
  172   Null           0     37    0                    0   
  173   Integer        385   36    0                    0   
  174   ReopenIdx      24    5     0     k(2,,)         0   
  175   Column         10    0     39                   0   
  176   IsNull         39    187   0                    0   
  177   SeekGE         24    187   39    1              0   
  178   Column         10    0     32                   0   
  179   Add            6     32    39                   0   
  180   IsNull         39    187   0                    0   
  181   IdxGT          24    187   39    1              0   
  182   DeferredSeek   24    0     11    [1,0]          0   
  183   IdxRowid       24    38    0                    0   
  184   RowSetTest     37    186   38    0              0   
  185   Gosub          36    386   0                    0   
  186   Next           24    181   0                    0   
  187   ReopenIdx      24    5     0     k(2,,)         2   
  188   BeginSubrtn    0     41    0     subrtnsig:6,A  0   
  189   Once           0     372   42                   0   
  190   OpenEphemeral  25    1     0     k(1,B)         0   
  191   Blob           10000  42    0                    0   
  192   OpenRead       14    3     0     1              0   
  193   OpenRead       15    3     0     1              0   
  194   OpenRead       13    4     0     1              0   
  195   IfEmpty        13    371   0                    0   
  196   Rewind         14    371   0                    0   
  197   Rewind         15    371   0                    0   
  198   Null           0     44    0                    0   
  199   Integer        303   43    0                    0   
  200   ReopenIdx      26    5     0     k(2,,)         0   
  201   Column         15    0     46                   0   
  202   IsNull         46    273   0                    0   
  203   SeekGE         26    273   46    1              0   
  204   Column         15    0     32                   0   
  205   Add            6     32    46                   0   
  206   IsNull         46    273   0                    0   
  207   IdxGT          26    273   46    1              0   
  208   DeferredSeek   26    0     13    [1,0]          0   
  209   Column         26    0     32                   0   
  210   BeginSubrtn    0     48    0                    0   
  211   Null           0     49    49                   0   
  212   InitCoroutine  50    239   213                  0   
  213   Column         26    0     53                   0   
  214   Column         14    0     55                   0   
  215   Integer        1     54    0                    0   
  216   Ge             55    218   53    BINARY-8       65  
  217   ZeroOrNull     53    54    55                   0   
  218   Column         14    0     57                   0   
  219   Add            6     57    56                   0   
  220   Integer        1     55    0                    0   
  221   Le             56    223   53    BINARY-8       65  
  222   ZeroOrNull     53    55    56                   0   
  223   And            55    54    52                   0   
  224   Column         26    0     55                   0   
  225   Null           0     54    0                    0   
  226   Column         26    0     56                   0   
  227   BitAnd         56    56    57                   0   
  228   Column         14    0     58                   0   
  229   BitAnd         57    58    57                   0   
  230   Eq             56    233   58    BINARY-8       65  
  231   IsNull         57    235   0                    0   
  232   Goto           0     234   0                    0   
  233   Integer        1     54    0                    0   
  234   AddImm         54    0     0                    0   
  235   And            54    55    53                   0   
  236   Or             53    52    51                   0   
  237   Yield          50    0     0                    0   
  238   EndCoroutine   50    0     0                    0   
  239   Integer        1     59    0                    0   
  240   OpenRead       17    3     0     1              0   
  241   InitCoroutine  50    0     213                  0   
  242   Yield          50    259   0                    0   
  243   Rewind         17    259   0                    0   
  244   Column         26    0     60                   0   
  245   Column         17    0     61                   0   
  246   Lt             61    250   60    BINARY-8       81  
  247   Column         17    0     62                   0   
  248   Add            6     62    61                   0   
  249   Le             61    255   60    BINARY-8       65  
  250   Column         26    0     60                   0   
  251   IfNot          60    257   1                    0   
  252   Column         26    0     60                   0   
  253   Column         17    0     61                   0   
  254   Ne             60    257   61    BINARY-8       81  
  255   Column         26    0     49                   0   
  256   DecrJumpZero   59    259   0                    0   
  257   Next           17    244   0                    1   
  258   Goto           0     242   0                    0   
  259   Return         48    211   1                    0   
  260   Lt             49    264   32    BINARY-8       81  
  261   Column         14    0     63                   0   
  262   Add            6     63    47                   0   
  263   Le             47    269   32    BINARY-8       65  
  264   Column         26    0     32                   0   
  265   IfNot          32    272   1                    0   
  266   Column         26    0     32                   0   
  267   Column         14    0     47                   0   
  268   Ne             32    272   47    BINARY-8       81  
  269   IdxRowid       26    45    0                    0   
  270   RowSetTest     44    272   45    0              0   
  271   Gosub          43    304   0                    0   
  272   Next           26    207   0                    0   
  273   ReopenIdx      26    5     0     k(2,,)         2   
  274   Noop           0     65    0                    0   
  275   Noop           0     0     0                    0   
  276   OpenEphemeral  27    1     0     k(1,B)         0   
  277   Column         15    0     47                   0   
  278   MakeRecord     47    1     63    A              0   
  279   IdxInsert      27    63    47    1              0   
  280   Rewind         27    303   0                    0   
  281   Column         27    0     64                   0   
  282   IsNull         64    302   0                    0   
  283   SeekGE         26    302   64    1              0   
  284   IdxGT          26    302   64    1              0   
  285   DeferredSeek   26    0     13    [1,0]          0   
  286   Column         26    0     63                   0   
  287   IfNot          63    302   1                    0   
  288   Column         26    0     63                   0   
  289   Gosub          48    211   0                    0   
  290   Lt             49    294   63    BINARY-8       81  
  291   Column         14    0     66                   0   
  292   Add            6     66    47                   0   
  293   Le             47    299   63    BINARY-8       65  
  294   Column         26    0     63                   0   
  295   IfNot          63    302   1                    0   
  296   Column         26    0     63                   0   
  297   Column         14    0     47                   0   
  298   Ne             63    302   47    BINARY-8       81  
  299   IdxRowid       26    45    0                    0   
  300   RowSetTest     44    302   45    -1             0   
  301   Gosub          43    304   0                    0   
  302   Next           27    281   0                    0   
  303   Goto           0     369   0                    0   
  304   Column         26    0     47                   0   
  305   BeginSubrtn    0     67    0                    0   
  306   Null           0     68    68                   0   
  307   InitCoroutine  69    334   308                  0   
  308   Column         26    0     72                   0   
  309   Column         14    0     74                   0   
  310   Integer        1     73    0                    0   
  311   Ge             74    313   72    BINARY-8       65  
  312   ZeroOrNull     72    73    74                   0   
  313   Column         14    0     76                   0   
  314   Add            6     76    75                   0   
  315   Integer        1     74    0                    0   
  316   Le             75    318   72    BINARY-8       65  
  317   ZeroOrNull     72    74    75                   0   
  318   And            74    73    71                   0   
  319   Column         26    0     74                   0   
  320   Null           0     73    0                    0   
  321   Column         26    0     75                   0   
  322   BitAnd         75    75    76                   0   
  323   Column         14    0     77                   0   
  324   BitAnd         76    77    76                   0   
  325   Eq             75    328   77    BINARY-8       65  
  326   IsNull         76    330   0                    0   
  327   Goto           0     329   0                    0   
  328   Integer        1     73    0                    0   
  329   AddImm         73    0     0                    0   
  330   And            73    74    72                   0   
  331   Or             72    71    70                   0   
  332   Yield          69    0     0                    0   
  333   EndCoroutine   69    0     0                    0   
  334   Integer        1     78    0                    0   
  335   OpenRead       17    3     0     1              0   
  336   InitCoroutine  69    0     308                  0   
  337   Yield          69    354   0                    0   
  338   Rewind         17    354   0                    0   
  339   Column         26    0     79                   0   
  340   Column         17    0     80                   0   
  341   Lt             80    345   79    BINARY-8       81  
  342   Column         17    0     81                   0   
  343   Add            6     81    80                   0   
  344   Le             80    350   79    BINARY-8       65  
  345   Column         26    0     79                   0   
  346   IfNot          79    352   1                    0   
  347   Column         26    0     79                   0   
  348   Column         17    0     80                   0   
  349   Ne             79    352   80    BINARY-8       81  
  350   Column         26    0     68                   0   
  351   DecrJumpZero   78    354   0                    0   
  352   Next           17    339   0                    1   
  353   Goto           0     337   0                    0   
  354   Return         67    306   1                    0   
  355   Lt             68    359   47    BINARY-8       81  
  356   Column         14    0     82                   0   
  357   Add            6     82    66                   0   
  358   Le             66    364   47    BINARY-8       65  
  359   Column         26    0     47                   0   
  360   IfNot          47    368   1                    0   
  361   Column         26    0     47                   0   
  362   Column         14    0     66                   0   
  363   Ne             47    368   66    BINARY-8       81  
  364   Column         26    0     83                   0   
  365   MakeRecord     83    1     66    A              0   
  366   IdxInsert      25    66    83    1              0   
  367   FilterAdd      42    0     83    1              0   
  368   Return         43    304   0                    0   
  369   Next           15    198   0                    1   
  370   Next           14    197   0                    1   
  371   NullRow        25    0     0                    0   
  372   Return         41    189   1                    0   
  373   Rewind         25    385   0                    0   
  374   Column         25    0     40                   0   
  375   IsNull         40    384   0                    0   
  376   SeekGE         24    384   40    1              0   
  377   IdxGT          24    384   40    1              0   
  378   DeferredSeek   24    0     11    [1,0]          0   
  379   Column         24    0     84                   0   
  380   IfNot          84    384   1                    0   
  381   IdxRowid       24    38    0                    0   
  382   RowSetTest     37    384   38    -1             0   
  383   Gosub          36    386   0                    0   
  384   Next           25    374   0                    0   
  385   Goto           0     389   0                    0   
  386   Integer        1     34    0                    0   
  387   DecrJumpZero   35    390   0                    0   
  388   Return         36    386   0                    0   
  389   Next           10    172   0                    1   
  390   Return         33    166   1                    0   
  391   If             34    395   1                    0   
  392   IdxRowid       20    12    0                    0   
  393   RowSetTest     11    395   12    -1             0   
  394   Gosub          10    397   0                    0   
  395   Next           23    149   0                    0   
  396   Goto           0     413   0                    0   
  397   Column         20    0     28                   0   
  398   Column         5     0     86                   0   
  399   Lt             86    403   28    BINARY-8       81  
  400   Column         5     0     87                   0   
  401   Add            6     87    86                   0   
  402   Le             86    408   28    BINARY-8       65  
  403   Column         20    0     28                   0   
  404   IfNot          28    412   1                    0   
  405   Column         20    0     28                   0   
  406   Column         5     0     86                   0   
  407   Ne             28    412   86    BINARY-8       81  
  408   Column         20    0     88                   0   
  409   MakeRecord     88    1     86    A              0   
  410   IdxInsert      19    86    88    1              0   
  411   FilterAdd      9     0     88    1              0   
  412   Return         10    397   0                    0   
  413   Next           5     30    0                    1   
  414   Next           4     29    0                    1   
  415   NullRow        19    0     0                    0   
  416   Return         8     21    1                    0   
  417   Rewind         19    429   0                    0   
  418   Column         19    0     7                    0   
  419   IsNull         7     428   0                    0   
  420   SeekGE         18    428   7     1              0   
  421   IdxGT          18    428   7     1              0   
  422   DeferredSeek   18    0     0     [1,0]          0   
  423   Column         18    0     89                   0   
  424   IfNot          89    428   1                    0   
  425   IdxRowid       18    3     0                    0   
  426   RowSetTest     2     428   3     -1             0   
  427   Gosub          1     430   0                    0   
  428   Next           19    418   0                    0   
  429   Goto           0     433   0                    0   
  430   Column         18    0     90                   0   
  431   ResultRow      90    1     0                    0   
  432   Return         1     430   0                    0   
  433   Next           1     4     0                    1   
  434   Halt           0     0     0                    0   
  435   Transaction    0     0     33    1              1   
  436   Integer        1     6     0                    0   
  437   Goto           0     1     0                    0   
-/

def program : Program := #[
  vdbeInit 0 435 0 "" 0,  -- 0: Init
  vdbeOpenRead 1 3 0 "1" 0,  -- 1: OpenRead
  vdbeOpenRead 0 4 0 "1" 0,  -- 2: OpenRead
  vdbeRewind 1 434 0 "" 0,  -- 3: Rewind
  vdbeNull 0 2 0 "" 0,  -- 4: Null
  vdbeInteger 429 1 0 "" 0,  -- 5: Integer
  vdbeReopenIdx 18 5 0 "k(2,,)" 0,  -- 6: ReopenIdx
  vdbeColumn 1 0 4 "" 0,  -- 7: Column
  vdbeIsNull 4 19 0 "" 0,  -- 8: IsNull
  vdbeSeekGE 18 19 4 "1" 0,  -- 9: SeekGE
  vdbeColumn 1 0 5 "" 0,  -- 10: Column
  vdbeAdd 6 5 4 "" 0,  -- 11: Add
  vdbeIsNull 4 19 0 "" 0,  -- 12: IsNull
  vdbeIdxGT 18 19 4 "1" 0,  -- 13: IdxGT
  vdbeDeferredSeek 18 0 0 "[1,0]" 0,  -- 14: DeferredSeek
  vdbeIdxRowid 18 3 0 "" 0,  -- 15: IdxRowid
  vdbeRowSetTest 2 18 3 "0" 0,  -- 16: RowSetTest
  vdbeGosub 1 430 0 "" 0,  -- 17: Gosub
  vdbeNext 18 13 0 "" 0,  -- 18: Next
  vdbeReopenIdx 18 5 0 "k(2,,)" 2,  -- 19: ReopenIdx
  vdbeBeginSubrtn 0 8 0 "subrtnsig:9,A" 0,  -- 20: BeginSubrtn
  vdbeOnce 0 416 9 "" 0,  -- 21: Once
  vdbeOpenEphemeral 19 1 0 "k(1,B)" 0,  -- 22: OpenEphemeral
  vdbeBlob 10000 9 0 "" 0,  -- 23: Blob
  vdbeOpenRead 4 3 0 "1" 0,  -- 24: OpenRead
  vdbeOpenRead 5 3 0 "1" 0,  -- 25: OpenRead
  vdbeOpenRead 3 4 0 "1" 0,  -- 26: OpenRead
  vdbeIfEmpty 3 415 0 "" 0,  -- 27: IfEmpty
  vdbeRewind 4 415 0 "" 0,  -- 28: Rewind
  vdbeRewind 5 415 0 "" 0,  -- 29: Rewind
  vdbeNull 0 11 0 "" 0,  -- 30: Null
  vdbeInteger 396 10 0 "" 0,  -- 31: Integer
  vdbeReopenIdx 20 5 0 "k(2,,)" 0,  -- 32: ReopenIdx
  vdbeBeginSubrtn 0 14 0 "" 0,  -- 33: BeginSubrtn
  vdbeOnce 0 117 0 "" 0,  -- 34: Once
  vdbeNull 0 15 15 "" 0,  -- 35: Null
  vdbeInteger 1 16 0 "" 0,  -- 36: Integer
  vdbeOpenRead 8 3 0 "1" 0,  -- 37: OpenRead
  vdbeOpenRead 9 3 0 "1" 0,  -- 38: OpenRead
  vdbeOpenRead 7 4 0 "1" 0,  -- 39: OpenRead
  vdbeIfEmpty 7 117 0 "" 0,  -- 40: IfEmpty
  vdbeRewind 8 117 0 "" 0,  -- 41: Rewind
  vdbeRewind 9 117 0 "" 0,  -- 42: Rewind
  vdbeNull 0 18 0 "" 0,  -- 43: Null
  vdbeInteger 99 17 0 "" 0,  -- 44: Integer
  vdbeReopenIdx 21 5 0 "k(2,,)" 0,  -- 45: ReopenIdx
  vdbeColumn 8 0 20 "" 0,  -- 46: Column
  vdbeIsNull 20 69 0 "" 0,  -- 47: IsNull
  vdbeSeekGE 21 69 20 "1" 0,  -- 48: SeekGE
  vdbeColumn 8 0 5 "" 0,  -- 49: Column
  vdbeAdd 6 5 20 "" 0,  -- 50: Add
  vdbeIsNull 20 69 0 "" 0,  -- 51: IsNull
  vdbeIdxGT 21 69 20 "1" 0,  -- 52: IdxGT
  vdbeDeferredSeek 21 0 7 "[1,0]" 0,  -- 53: DeferredSeek
  vdbeColumn 21 0 5 "" 0,  -- 54: Column
  vdbeColumn 9 0 21 "" 0,  -- 55: Column
  vdbeLt 21 60 5 "RTRIM-8" 81,  -- 56: Lt
  vdbeColumn 9 0 22 "" 0,  -- 57: Column
  vdbeAdd 6 22 21 "" 0,  -- 58: Add
  vdbeLe 21 65 5 "RTRIM-8" 65,  -- 59: Le
  vdbeColumn 21 0 5 "" 0,  -- 60: Column
  vdbeIfNot 5 68 1 "" 0,  -- 61: IfNot
  vdbeColumn 21 0 5 "" 0,  -- 62: Column
  vdbeColumn 9 0 21 "" 0,  -- 63: Column
  vdbeNe 5 68 21 "RTRIM-8" 81,  -- 64: Ne
  vdbeIdxRowid 21 19 0 "" 0,  -- 65: IdxRowid
  vdbeRowSetTest 18 68 19 "0" 0,  -- 66: RowSetTest
  vdbeGosub 17 100 0 "" 0,  -- 67: Gosub
  vdbeNext 21 52 0 "" 0,  -- 68: Next
  vdbeReopenIdx 21 5 0 "k(2,,)" 2,  -- 69: ReopenIdx
  vdbeNoop 0 24 0 "" 0,  -- 70: Noop
  vdbeNoop 0 0 0 "" 0,  -- 71: Noop
  vdbeOpenEphemeral 22 1 0 "k(1,B)" 0,  -- 72: OpenEphemeral
  vdbeColumn 8 0 21 "" 0,  -- 73: Column
  vdbeMakeRecord 21 1 22 "A" 0,  -- 74: MakeRecord
  vdbeIdxInsert 22 22 21 "1" 0,  -- 75: IdxInsert
  vdbeRewind 22 99 0 "" 0,  -- 76: Rewind
  vdbeColumn 22 0 23 "" 0,  -- 77: Column
  vdbeIsNull 23 98 0 "" 0,  -- 78: IsNull
  vdbeSeekGE 21 98 23 "1" 0,  -- 79: SeekGE
  vdbeIdxGT 21 98 23 "1" 0,  -- 80: IdxGT
  vdbeDeferredSeek 21 0 7 "[1,0]" 0,  -- 81: DeferredSeek
  vdbeColumn 21 0 22 "" 0,  -- 82: Column
  vdbeIfNot 22 98 1 "" 0,  -- 83: IfNot
  vdbeColumn 21 0 22 "" 0,  -- 84: Column
  vdbeColumn 9 0 21 "" 0,  -- 85: Column
  vdbeLt 21 90 22 "RTRIM-8" 81,  -- 86: Lt
  vdbeColumn 9 0 25 "" 0,  -- 87: Column
  vdbeAdd 6 25 21 "" 0,  -- 88: Add
  vdbeLe 21 95 22 "RTRIM-8" 65,  -- 89: Le
  vdbeColumn 21 0 22 "" 0,  -- 90: Column
  vdbeIfNot 22 98 1 "" 0,  -- 91: IfNot
  vdbeColumn 21 0 22 "" 0,  -- 92: Column
  vdbeColumn 9 0 21 "" 0,  -- 93: Column
  vdbeNe 22 98 21 "RTRIM-8" 81,  -- 94: Ne
  vdbeIdxRowid 21 19 0 "" 0,  -- 95: IdxRowid
  vdbeRowSetTest 18 98 19 "-1" 0,  -- 96: RowSetTest
  vdbeGosub 17 100 0 "" 0,  -- 97: Gosub
  vdbeNext 22 77 0 "" 0,  -- 98: Next
  vdbeGoto 0 115 0 "" 0,  -- 99: Goto
  vdbeColumn 21 0 21 "" 0,  -- 100: Column
  vdbeColumn 9 0 25 "" 0,  -- 101: Column
  vdbeLt 25 106 21 "RTRIM-8" 81,  -- 102: Lt
  vdbeColumn 9 0 26 "" 0,  -- 103: Column
  vdbeAdd 6 26 25 "" 0,  -- 104: Add
  vdbeLe 25 111 21 "RTRIM-8" 65,  -- 105: Le
  vdbeColumn 21 0 21 "" 0,  -- 106: Column
  vdbeIfNot 21 114 1 "" 0,  -- 107: IfNot
  vdbeColumn 21 0 21 "" 0,  -- 108: Column
  vdbeColumn 9 0 25 "" 0,  -- 109: Column
  vdbeNe 21 114 25 "RTRIM-8" 81,  -- 110: Ne
  vdbeColumn 21 0 15 "" 0,  -- 111: Column
  vdbeClrSubtype 15 0 0 "" 0,  -- 112: ClrSubtype
  vdbeDecrJumpZero 16 117 0 "" 0,  -- 113: DecrJumpZero
  vdbeReturn 17 100 0 "" 0,  -- 114: Return
  vdbeNext 9 43 0 "" 1,  -- 115: Next
  vdbeNext 8 42 0 "" 1,  -- 116: Next
  vdbeReturn 14 34 1 "" 0,  -- 117: Return
  vdbeCopy 15 13 0 "" 0,  -- 118: Copy
  vdbeIsNull 13 141 0 "" 0,  -- 119: IsNull
  vdbeSeekGE 20 141 13 "1" 0,  -- 120: SeekGE
  vdbeColumn 4 0 27 "" 0,  -- 121: Column
  vdbeAdd 6 27 13 "" 0,  -- 122: Add
  vdbeIsNull 13 141 0 "" 0,  -- 123: IsNull
  vdbeIdxGT 20 141 13 "1" 0,  -- 124: IdxGT
  vdbeDeferredSeek 20 0 3 "[1,0]" 0,  -- 125: DeferredSeek
  vdbeColumn 20 0 27 "" 0,  -- 126: Column
  vdbeColumn 5 0 28 "" 0,  -- 127: Column
  vdbeLt 28 132 27 "BINARY-8" 81,  -- 128: Lt
  vdbeColumn 5 0 29 "" 0,  -- 129: Column
  vdbeAdd 6 29 28 "" 0,  -- 130: Add
  vdbeLe 28 137 27 "BINARY-8" 65,  -- 131: Le
  vdbeColumn 20 0 27 "" 0,  -- 132: Column
  vdbeIfNot 27 140 1 "" 0,  -- 133: IfNot
  vdbeColumn 20 0 27 "" 0,  -- 134: Column
  vdbeColumn 5 0 28 "" 0,  -- 135: Column
  vdbeNe 27 140 28 "BINARY-8" 81,  -- 136: Ne
  vdbeIdxRowid 20 12 0 "" 0,  -- 137: IdxRowid
  vdbeRowSetTest 11 140 12 "0" 0,  -- 138: RowSetTest
  vdbeGosub 10 397 0 "" 0,  -- 139: Gosub
  vdbeNext 20 124 0 "" 0,  -- 140: Next
  vdbeReopenIdx 20 5 0 "k(2,,)" 2,  -- 141: ReopenIdx
  vdbeNoop 0 31 0 "" 0,  -- 142: Noop
  vdbeNoop 0 0 0 "" 0,  -- 143: Noop
  vdbeOpenEphemeral 23 1 0 "k(1,B)" 0,  -- 144: OpenEphemeral
  vdbeColumn 4 0 28 "" 0,  -- 145: Column
  vdbeMakeRecord 28 1 29 "A" 0,  -- 146: MakeRecord
  vdbeIdxInsert 23 29 28 "1" 0,  -- 147: IdxInsert
  vdbeRewind 23 396 0 "" 0,  -- 148: Rewind
  vdbeColumn 23 0 30 "" 0,  -- 149: Column
  vdbeIsNull 30 395 0 "" 0,  -- 150: IsNull
  vdbeSeekGE 20 395 30 "1" 0,  -- 151: SeekGE
  vdbeIdxGT 20 395 30 "1" 0,  -- 152: IdxGT
  vdbeDeferredSeek 20 0 3 "[1,0]" 0,  -- 153: DeferredSeek
  vdbeColumn 20 0 29 "" 0,  -- 154: Column
  vdbeColumn 5 0 28 "" 0,  -- 155: Column
  vdbeLt 28 160 29 "BINARY-8" 81,  -- 156: Lt
  vdbeColumn 5 0 32 "" 0,  -- 157: Column
  vdbeAdd 6 32 28 "" 0,  -- 158: Add
  vdbeLe 28 165 29 "BINARY-8" 65,  -- 159: Le
  vdbeColumn 20 0 29 "" 0,  -- 160: Column
  vdbeIfNot 29 395 1 "" 0,  -- 161: IfNot
  vdbeColumn 20 0 29 "" 0,  -- 162: Column
  vdbeColumn 5 0 28 "" 0,  -- 163: Column
  vdbeNe 29 395 28 "BINARY-8" 81,  -- 164: Ne
  vdbeBeginSubrtn 0 33 0 "" 0,  -- 165: BeginSubrtn
  vdbeOnce 0 390 0 "" 0,  -- 166: Once
  vdbeInteger 0 34 0 "" 0,  -- 167: Integer
  vdbeInteger 1 35 0 "" 0,  -- 168: Integer
  vdbeOpenRead 10 3 0 "1" 0,  -- 169: OpenRead
  vdbeOpenRead 11 4 0 "1" 0,  -- 170: OpenRead
  vdbeRewind 10 390 0 "" 0,  -- 171: Rewind
  vdbeNull 0 37 0 "" 0,  -- 172: Null
  vdbeInteger 385 36 0 "" 0,  -- 173: Integer
  vdbeReopenIdx 24 5 0 "k(2,,)" 0,  -- 174: ReopenIdx
  vdbeColumn 10 0 39 "" 0,  -- 175: Column
  vdbeIsNull 39 187 0 "" 0,  -- 176: IsNull
  vdbeSeekGE 24 187 39 "1" 0,  -- 177: SeekGE
  vdbeColumn 10 0 32 "" 0,  -- 178: Column
  vdbeAdd 6 32 39 "" 0,  -- 179: Add
  vdbeIsNull 39 187 0 "" 0,  -- 180: IsNull
  vdbeIdxGT 24 187 39 "1" 0,  -- 181: IdxGT
  vdbeDeferredSeek 24 0 11 "[1,0]" 0,  -- 182: DeferredSeek
  vdbeIdxRowid 24 38 0 "" 0,  -- 183: IdxRowid
  vdbeRowSetTest 37 186 38 "0" 0,  -- 184: RowSetTest
  vdbeGosub 36 386 0 "" 0,  -- 185: Gosub
  vdbeNext 24 181 0 "" 0,  -- 186: Next
  vdbeReopenIdx 24 5 0 "k(2,,)" 2,  -- 187: ReopenIdx
  vdbeBeginSubrtn 0 41 0 "subrtnsig:6,A" 0,  -- 188: BeginSubrtn
  vdbeOnce 0 372 42 "" 0,  -- 189: Once
  vdbeOpenEphemeral 25 1 0 "k(1,B)" 0,  -- 190: OpenEphemeral
  vdbeBlob 10000 42 0 "" 0,  -- 191: Blob
  vdbeOpenRead 14 3 0 "1" 0,  -- 192: OpenRead
  vdbeOpenRead 15 3 0 "1" 0,  -- 193: OpenRead
  vdbeOpenRead 13 4 0 "1" 0,  -- 194: OpenRead
  vdbeIfEmpty 13 371 0 "" 0,  -- 195: IfEmpty
  vdbeRewind 14 371 0 "" 0,  -- 196: Rewind
  vdbeRewind 15 371 0 "" 0,  -- 197: Rewind
  vdbeNull 0 44 0 "" 0,  -- 198: Null
  vdbeInteger 303 43 0 "" 0,  -- 199: Integer
  vdbeReopenIdx 26 5 0 "k(2,,)" 0,  -- 200: ReopenIdx
  vdbeColumn 15 0 46 "" 0,  -- 201: Column
  vdbeIsNull 46 273 0 "" 0,  -- 202: IsNull
  vdbeSeekGE 26 273 46 "1" 0,  -- 203: SeekGE
  vdbeColumn 15 0 32 "" 0,  -- 204: Column
  vdbeAdd 6 32 46 "" 0,  -- 205: Add
  vdbeIsNull 46 273 0 "" 0,  -- 206: IsNull
  vdbeIdxGT 26 273 46 "1" 0,  -- 207: IdxGT
  vdbeDeferredSeek 26 0 13 "[1,0]" 0,  -- 208: DeferredSeek
  vdbeColumn 26 0 32 "" 0,  -- 209: Column
  vdbeBeginSubrtn 0 48 0 "" 0,  -- 210: BeginSubrtn
  vdbeNull 0 49 49 "" 0,  -- 211: Null
  vdbeInitCoroutine 50 239 213 "" 0,  -- 212: InitCoroutine
  vdbeColumn 26 0 53 "" 0,  -- 213: Column
  vdbeColumn 14 0 55 "" 0,  -- 214: Column
  vdbeInteger 1 54 0 "" 0,  -- 215: Integer
  vdbeGe 55 218 53 "BINARY-8" 65,  -- 216: Ge
  vdbeZeroOrNull 53 54 55 "" 0,  -- 217: ZeroOrNull
  vdbeColumn 14 0 57 "" 0,  -- 218: Column
  vdbeAdd 6 57 56 "" 0,  -- 219: Add
  vdbeInteger 1 55 0 "" 0,  -- 220: Integer
  vdbeLe 56 223 53 "BINARY-8" 65,  -- 221: Le
  vdbeZeroOrNull 53 55 56 "" 0,  -- 222: ZeroOrNull
  vdbeAnd 55 54 52 "" 0,  -- 223: And
  vdbeColumn 26 0 55 "" 0,  -- 224: Column
  vdbeNull 0 54 0 "" 0,  -- 225: Null
  vdbeColumn 26 0 56 "" 0,  -- 226: Column
  vdbeBitAnd 56 56 57 "" 0,  -- 227: BitAnd
  vdbeColumn 14 0 58 "" 0,  -- 228: Column
  vdbeBitAnd 57 58 57 "" 0,  -- 229: BitAnd
  vdbeEq 56 233 58 "BINARY-8" 65,  -- 230: Eq
  vdbeIsNull 57 235 0 "" 0,  -- 231: IsNull
  vdbeGoto 0 234 0 "" 0,  -- 232: Goto
  vdbeInteger 1 54 0 "" 0,  -- 233: Integer
  vdbeAddImm 54 0 0 "" 0,  -- 234: AddImm
  vdbeAnd 54 55 53 "" 0,  -- 235: And
  vdbeOr 53 52 51 "" 0,  -- 236: Or
  vdbeYield 50 0 0 "" 0,  -- 237: Yield
  vdbeEndCoroutine 50 0 0 "" 0,  -- 238: EndCoroutine
  vdbeInteger 1 59 0 "" 0,  -- 239: Integer
  vdbeOpenRead 17 3 0 "1" 0,  -- 240: OpenRead
  vdbeInitCoroutine 50 0 213 "" 0,  -- 241: InitCoroutine
  vdbeYield 50 259 0 "" 0,  -- 242: Yield
  vdbeRewind 17 259 0 "" 0,  -- 243: Rewind
  vdbeColumn 26 0 60 "" 0,  -- 244: Column
  vdbeColumn 17 0 61 "" 0,  -- 245: Column
  vdbeLt 61 250 60 "BINARY-8" 81,  -- 246: Lt
  vdbeColumn 17 0 62 "" 0,  -- 247: Column
  vdbeAdd 6 62 61 "" 0,  -- 248: Add
  vdbeLe 61 255 60 "BINARY-8" 65,  -- 249: Le
  vdbeColumn 26 0 60 "" 0,  -- 250: Column
  vdbeIfNot 60 257 1 "" 0,  -- 251: IfNot
  vdbeColumn 26 0 60 "" 0,  -- 252: Column
  vdbeColumn 17 0 61 "" 0,  -- 253: Column
  vdbeNe 60 257 61 "BINARY-8" 81,  -- 254: Ne
  vdbeColumn 26 0 49 "" 0,  -- 255: Column
  vdbeDecrJumpZero 59 259 0 "" 0,  -- 256: DecrJumpZero
  vdbeNext 17 244 0 "" 1,  -- 257: Next
  vdbeGoto 0 242 0 "" 0,  -- 258: Goto
  vdbeReturn 48 211 1 "" 0,  -- 259: Return
  vdbeLt 49 264 32 "BINARY-8" 81,  -- 260: Lt
  vdbeColumn 14 0 63 "" 0,  -- 261: Column
  vdbeAdd 6 63 47 "" 0,  -- 262: Add
  vdbeLe 47 269 32 "BINARY-8" 65,  -- 263: Le
  vdbeColumn 26 0 32 "" 0,  -- 264: Column
  vdbeIfNot 32 272 1 "" 0,  -- 265: IfNot
  vdbeColumn 26 0 32 "" 0,  -- 266: Column
  vdbeColumn 14 0 47 "" 0,  -- 267: Column
  vdbeNe 32 272 47 "BINARY-8" 81,  -- 268: Ne
  vdbeIdxRowid 26 45 0 "" 0,  -- 269: IdxRowid
  vdbeRowSetTest 44 272 45 "0" 0,  -- 270: RowSetTest
  vdbeGosub 43 304 0 "" 0,  -- 271: Gosub
  vdbeNext 26 207 0 "" 0,  -- 272: Next
  vdbeReopenIdx 26 5 0 "k(2,,)" 2,  -- 273: ReopenIdx
  vdbeNoop 0 65 0 "" 0,  -- 274: Noop
  vdbeNoop 0 0 0 "" 0,  -- 275: Noop
  vdbeOpenEphemeral 27 1 0 "k(1,B)" 0,  -- 276: OpenEphemeral
  vdbeColumn 15 0 47 "" 0,  -- 277: Column
  vdbeMakeRecord 47 1 63 "A" 0,  -- 278: MakeRecord
  vdbeIdxInsert 27 63 47 "1" 0,  -- 279: IdxInsert
  vdbeRewind 27 303 0 "" 0,  -- 280: Rewind
  vdbeColumn 27 0 64 "" 0,  -- 281: Column
  vdbeIsNull 64 302 0 "" 0,  -- 282: IsNull
  vdbeSeekGE 26 302 64 "1" 0,  -- 283: SeekGE
  vdbeIdxGT 26 302 64 "1" 0,  -- 284: IdxGT
  vdbeDeferredSeek 26 0 13 "[1,0]" 0,  -- 285: DeferredSeek
  vdbeColumn 26 0 63 "" 0,  -- 286: Column
  vdbeIfNot 63 302 1 "" 0,  -- 287: IfNot
  vdbeColumn 26 0 63 "" 0,  -- 288: Column
  vdbeGosub 48 211 0 "" 0,  -- 289: Gosub
  vdbeLt 49 294 63 "BINARY-8" 81,  -- 290: Lt
  vdbeColumn 14 0 66 "" 0,  -- 291: Column
  vdbeAdd 6 66 47 "" 0,  -- 292: Add
  vdbeLe 47 299 63 "BINARY-8" 65,  -- 293: Le
  vdbeColumn 26 0 63 "" 0,  -- 294: Column
  vdbeIfNot 63 302 1 "" 0,  -- 295: IfNot
  vdbeColumn 26 0 63 "" 0,  -- 296: Column
  vdbeColumn 14 0 47 "" 0,  -- 297: Column
  vdbeNe 63 302 47 "BINARY-8" 81,  -- 298: Ne
  vdbeIdxRowid 26 45 0 "" 0,  -- 299: IdxRowid
  vdbeRowSetTest 44 302 45 "-1" 0,  -- 300: RowSetTest
  vdbeGosub 43 304 0 "" 0,  -- 301: Gosub
  vdbeNext 27 281 0 "" 0,  -- 302: Next
  vdbeGoto 0 369 0 "" 0,  -- 303: Goto
  vdbeColumn 26 0 47 "" 0,  -- 304: Column
  vdbeBeginSubrtn 0 67 0 "" 0,  -- 305: BeginSubrtn
  vdbeNull 0 68 68 "" 0,  -- 306: Null
  vdbeInitCoroutine 69 334 308 "" 0,  -- 307: InitCoroutine
  vdbeColumn 26 0 72 "" 0,  -- 308: Column
  vdbeColumn 14 0 74 "" 0,  -- 309: Column
  vdbeInteger 1 73 0 "" 0,  -- 310: Integer
  vdbeGe 74 313 72 "BINARY-8" 65,  -- 311: Ge
  vdbeZeroOrNull 72 73 74 "" 0,  -- 312: ZeroOrNull
  vdbeColumn 14 0 76 "" 0,  -- 313: Column
  vdbeAdd 6 76 75 "" 0,  -- 314: Add
  vdbeInteger 1 74 0 "" 0,  -- 315: Integer
  vdbeLe 75 318 72 "BINARY-8" 65,  -- 316: Le
  vdbeZeroOrNull 72 74 75 "" 0,  -- 317: ZeroOrNull
  vdbeAnd 74 73 71 "" 0,  -- 318: And
  vdbeColumn 26 0 74 "" 0,  -- 319: Column
  vdbeNull 0 73 0 "" 0,  -- 320: Null
  vdbeColumn 26 0 75 "" 0,  -- 321: Column
  vdbeBitAnd 75 75 76 "" 0,  -- 322: BitAnd
  vdbeColumn 14 0 77 "" 0,  -- 323: Column
  vdbeBitAnd 76 77 76 "" 0,  -- 324: BitAnd
  vdbeEq 75 328 77 "BINARY-8" 65,  -- 325: Eq
  vdbeIsNull 76 330 0 "" 0,  -- 326: IsNull
  vdbeGoto 0 329 0 "" 0,  -- 327: Goto
  vdbeInteger 1 73 0 "" 0,  -- 328: Integer
  vdbeAddImm 73 0 0 "" 0,  -- 329: AddImm
  vdbeAnd 73 74 72 "" 0,  -- 330: And
  vdbeOr 72 71 70 "" 0,  -- 331: Or
  vdbeYield 69 0 0 "" 0,  -- 332: Yield
  vdbeEndCoroutine 69 0 0 "" 0,  -- 333: EndCoroutine
  vdbeInteger 1 78 0 "" 0,  -- 334: Integer
  vdbeOpenRead 17 3 0 "1" 0,  -- 335: OpenRead
  vdbeInitCoroutine 69 0 308 "" 0,  -- 336: InitCoroutine
  vdbeYield 69 354 0 "" 0,  -- 337: Yield
  vdbeRewind 17 354 0 "" 0,  -- 338: Rewind
  vdbeColumn 26 0 79 "" 0,  -- 339: Column
  vdbeColumn 17 0 80 "" 0,  -- 340: Column
  vdbeLt 80 345 79 "BINARY-8" 81,  -- 341: Lt
  vdbeColumn 17 0 81 "" 0,  -- 342: Column
  vdbeAdd 6 81 80 "" 0,  -- 343: Add
  vdbeLe 80 350 79 "BINARY-8" 65,  -- 344: Le
  vdbeColumn 26 0 79 "" 0,  -- 345: Column
  vdbeIfNot 79 352 1 "" 0,  -- 346: IfNot
  vdbeColumn 26 0 79 "" 0,  -- 347: Column
  vdbeColumn 17 0 80 "" 0,  -- 348: Column
  vdbeNe 79 352 80 "BINARY-8" 81,  -- 349: Ne
  vdbeColumn 26 0 68 "" 0,  -- 350: Column
  vdbeDecrJumpZero 78 354 0 "" 0,  -- 351: DecrJumpZero
  vdbeNext 17 339 0 "" 1,  -- 352: Next
  vdbeGoto 0 337 0 "" 0,  -- 353: Goto
  vdbeReturn 67 306 1 "" 0,  -- 354: Return
  vdbeLt 68 359 47 "BINARY-8" 81,  -- 355: Lt
  vdbeColumn 14 0 82 "" 0,  -- 356: Column
  vdbeAdd 6 82 66 "" 0,  -- 357: Add
  vdbeLe 66 364 47 "BINARY-8" 65,  -- 358: Le
  vdbeColumn 26 0 47 "" 0,  -- 359: Column
  vdbeIfNot 47 368 1 "" 0,  -- 360: IfNot
  vdbeColumn 26 0 47 "" 0,  -- 361: Column
  vdbeColumn 14 0 66 "" 0,  -- 362: Column
  vdbeNe 47 368 66 "BINARY-8" 81,  -- 363: Ne
  vdbeColumn 26 0 83 "" 0,  -- 364: Column
  vdbeMakeRecord 83 1 66 "A" 0,  -- 365: MakeRecord
  vdbeIdxInsert 25 66 83 "1" 0,  -- 366: IdxInsert
  vdbeFilterAdd 42 0 83 "1" 0,  -- 367: FilterAdd
  vdbeReturn 43 304 0 "" 0,  -- 368: Return
  vdbeNext 15 198 0 "" 1,  -- 369: Next
  vdbeNext 14 197 0 "" 1,  -- 370: Next
  vdbeNullRow 25 0 0 "" 0,  -- 371: NullRow
  vdbeReturn 41 189 1 "" 0,  -- 372: Return
  vdbeRewind 25 385 0 "" 0,  -- 373: Rewind
  vdbeColumn 25 0 40 "" 0,  -- 374: Column
  vdbeIsNull 40 384 0 "" 0,  -- 375: IsNull
  vdbeSeekGE 24 384 40 "1" 0,  -- 376: SeekGE
  vdbeIdxGT 24 384 40 "1" 0,  -- 377: IdxGT
  vdbeDeferredSeek 24 0 11 "[1,0]" 0,  -- 378: DeferredSeek
  vdbeColumn 24 0 84 "" 0,  -- 379: Column
  vdbeIfNot 84 384 1 "" 0,  -- 380: IfNot
  vdbeIdxRowid 24 38 0 "" 0,  -- 381: IdxRowid
  vdbeRowSetTest 37 384 38 "-1" 0,  -- 382: RowSetTest
  vdbeGosub 36 386 0 "" 0,  -- 383: Gosub
  vdbeNext 25 374 0 "" 0,  -- 384: Next
  vdbeGoto 0 389 0 "" 0,  -- 385: Goto
  vdbeInteger 1 34 0 "" 0,  -- 386: Integer
  vdbeDecrJumpZero 35 390 0 "" 0,  -- 387: DecrJumpZero
  vdbeReturn 36 386 0 "" 0,  -- 388: Return
  vdbeNext 10 172 0 "" 1,  -- 389: Next
  vdbeReturn 33 166 1 "" 0,  -- 390: Return
  vdbeIf 34 395 1 "" 0,  -- 391: If
  vdbeIdxRowid 20 12 0 "" 0,  -- 392: IdxRowid
  vdbeRowSetTest 11 395 12 "-1" 0,  -- 393: RowSetTest
  vdbeGosub 10 397 0 "" 0,  -- 394: Gosub
  vdbeNext 23 149 0 "" 0,  -- 395: Next
  vdbeGoto 0 413 0 "" 0,  -- 396: Goto
  vdbeColumn 20 0 28 "" 0,  -- 397: Column
  vdbeColumn 5 0 86 "" 0,  -- 398: Column
  vdbeLt 86 403 28 "BINARY-8" 81,  -- 399: Lt
  vdbeColumn 5 0 87 "" 0,  -- 400: Column
  vdbeAdd 6 87 86 "" 0,  -- 401: Add
  vdbeLe 86 408 28 "BINARY-8" 65,  -- 402: Le
  vdbeColumn 20 0 28 "" 0,  -- 403: Column
  vdbeIfNot 28 412 1 "" 0,  -- 404: IfNot
  vdbeColumn 20 0 28 "" 0,  -- 405: Column
  vdbeColumn 5 0 86 "" 0,  -- 406: Column
  vdbeNe 28 412 86 "BINARY-8" 81,  -- 407: Ne
  vdbeColumn 20 0 88 "" 0,  -- 408: Column
  vdbeMakeRecord 88 1 86 "A" 0,  -- 409: MakeRecord
  vdbeIdxInsert 19 86 88 "1" 0,  -- 410: IdxInsert
  vdbeFilterAdd 9 0 88 "1" 0,  -- 411: FilterAdd
  vdbeReturn 10 397 0 "" 0,  -- 412: Return
  vdbeNext 5 30 0 "" 1,  -- 413: Next
  vdbeNext 4 29 0 "" 1,  -- 414: Next
  vdbeNullRow 19 0 0 "" 0,  -- 415: NullRow
  vdbeReturn 8 21 1 "" 0,  -- 416: Return
  vdbeRewind 19 429 0 "" 0,  -- 417: Rewind
  vdbeColumn 19 0 7 "" 0,  -- 418: Column
  vdbeIsNull 7 428 0 "" 0,  -- 419: IsNull
  vdbeSeekGE 18 428 7 "1" 0,  -- 420: SeekGE
  vdbeIdxGT 18 428 7 "1" 0,  -- 421: IdxGT
  vdbeDeferredSeek 18 0 0 "[1,0]" 0,  -- 422: DeferredSeek
  vdbeColumn 18 0 89 "" 0,  -- 423: Column
  vdbeIfNot 89 428 1 "" 0,  -- 424: IfNot
  vdbeIdxRowid 18 3 0 "" 0,  -- 425: IdxRowid
  vdbeRowSetTest 2 428 3 "-1" 0,  -- 426: RowSetTest
  vdbeGosub 1 430 0 "" 0,  -- 427: Gosub
  vdbeNext 19 418 0 "" 0,  -- 428: Next
  vdbeGoto 0 433 0 "" 0,  -- 429: Goto
  vdbeColumn 18 0 90 "" 0,  -- 430: Column
  vdbeResultRow 90 1 0 "" 0,  -- 431: ResultRow
  vdbeReturn 1 430 0 "" 0,  -- 432: Return
  vdbeNext 1 4 0 "" 1,  -- 433: Next
  vdbeHalt 0 0 0 "" 0,  -- 434: Halt
  vdbeTransaction 0 0 33 "1" 1,  -- 435: Transaction
  vdbeInteger 1 6 0 "" 0,  -- 436: Integer
  vdbeGoto 0 1 0 "" 0  -- 437: Goto
]

def program_gas (state : VMState) : Nat := sorry
theorem program_terminates (db : Database) : ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := sorry
theorem program_terminates' (db : Database) : (runBounded program (mkInitialState db) (program_gas (mkInitialState db))).status ≠ .running := sorry

end Sqlite3Lean.select1.Query000147

import Sqlite3Lean.Vdbe
import Sqlite3Lean.VdbeLemmas

namespace Sqlite3Lean.Query000147

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
  .init 0 435 0 0 0,  -- 0: Init
  .openRead 1 3 0 1 0,  -- 1: OpenRead
  .openRead 0 4 0 1 0,  -- 2: OpenRead
  .rewind 1 434 0 0 0,  -- 3: Rewind
  .null 0 2 0 0 0,  -- 4: Null
  .integer 429 1 0 0 0,  -- 5: Integer
  .reopenIdx 18 5 0 "k(2,,)" 0,  -- 6: ReopenIdx
  .column 1 0 4 0 0,  -- 7: Column
  .isNull 4 19 0 0 0,  -- 8: IsNull
  .seekGE 18 19 4 1 0,  -- 9: SeekGE
  .column 1 0 5 0 0,  -- 10: Column
  .add 6 5 4 0 0,  -- 11: Add
  .isNull 4 19 0 0 0,  -- 12: IsNull
  .idxGT 18 19 4 1 0,  -- 13: IdxGT
  .deferredSeek 18 0 0 "[1,0]" 0,  -- 14: DeferredSeek
  .idxRowid 18 3 0 0 0,  -- 15: IdxRowid
  .rowSetTest 2 18 3 0 0,  -- 16: RowSetTest
  .gosub 1 430 0 0 0,  -- 17: Gosub
  .next 18 13 0 0 0,  -- 18: Next
  .reopenIdx 18 5 0 "k(2,,)" 2,  -- 19: ReopenIdx
  .beginSubrtn 0 8 0 "subrtnsig:9,A" 0,  -- 20: BeginSubrtn
  .once 0 416 9 0 0,  -- 21: Once
  .openEphemeral 19 1 0 "k(1,B)" 0,  -- 22: OpenEphemeral
  .blob 10000 9 0 0 0,  -- 23: Blob
  .openRead 4 3 0 1 0,  -- 24: OpenRead
  .openRead 5 3 0 1 0,  -- 25: OpenRead
  .openRead 3 4 0 1 0,  -- 26: OpenRead
  .ifEmpty 3 415 0 0 0,  -- 27: IfEmpty
  .rewind 4 415 0 0 0,  -- 28: Rewind
  .rewind 5 415 0 0 0,  -- 29: Rewind
  .null 0 11 0 0 0,  -- 30: Null
  .integer 396 10 0 0 0,  -- 31: Integer
  .reopenIdx 20 5 0 "k(2,,)" 0,  -- 32: ReopenIdx
  .beginSubrtn 0 14 0 0 0,  -- 33: BeginSubrtn
  .once 0 117 0 0 0,  -- 34: Once
  .null 0 15 15 0 0,  -- 35: Null
  .integer 1 16 0 0 0,  -- 36: Integer
  .openRead 8 3 0 1 0,  -- 37: OpenRead
  .openRead 9 3 0 1 0,  -- 38: OpenRead
  .openRead 7 4 0 1 0,  -- 39: OpenRead
  .ifEmpty 7 117 0 0 0,  -- 40: IfEmpty
  .rewind 8 117 0 0 0,  -- 41: Rewind
  .rewind 9 117 0 0 0,  -- 42: Rewind
  .null 0 18 0 0 0,  -- 43: Null
  .integer 99 17 0 0 0,  -- 44: Integer
  .reopenIdx 21 5 0 "k(2,,)" 0,  -- 45: ReopenIdx
  .column 8 0 20 0 0,  -- 46: Column
  .isNull 20 69 0 0 0,  -- 47: IsNull
  .seekGE 21 69 20 1 0,  -- 48: SeekGE
  .column 8 0 5 0 0,  -- 49: Column
  .add 6 5 20 0 0,  -- 50: Add
  .isNull 20 69 0 0 0,  -- 51: IsNull
  .idxGT 21 69 20 1 0,  -- 52: IdxGT
  .deferredSeek 21 0 7 "[1,0]" 0,  -- 53: DeferredSeek
  .column 21 0 5 0 0,  -- 54: Column
  .column 9 0 21 0 0,  -- 55: Column
  .lt 21 60 5 "RTRIM-8" 81,  -- 56: Lt
  .column 9 0 22 0 0,  -- 57: Column
  .add 6 22 21 0 0,  -- 58: Add
  .le 21 65 5 "RTRIM-8" 65,  -- 59: Le
  .column 21 0 5 0 0,  -- 60: Column
  .ifNot 5 68 1 0 0,  -- 61: IfNot
  .column 21 0 5 0 0,  -- 62: Column
  .column 9 0 21 0 0,  -- 63: Column
  .ne 5 68 21 "RTRIM-8" 81,  -- 64: Ne
  .idxRowid 21 19 0 0 0,  -- 65: IdxRowid
  .rowSetTest 18 68 19 0 0,  -- 66: RowSetTest
  .gosub 17 100 0 0 0,  -- 67: Gosub
  .next 21 52 0 0 0,  -- 68: Next
  .reopenIdx 21 5 0 "k(2,,)" 2,  -- 69: ReopenIdx
  .noop 0 24 0 0 0,  -- 70: Noop
  .noop 0 0 0 0 0,  -- 71: Noop
  .openEphemeral 22 1 0 "k(1,B)" 0,  -- 72: OpenEphemeral
  .column 8 0 21 0 0,  -- 73: Column
  .makeRecord 21 1 22 "A" 0,  -- 74: MakeRecord
  .idxInsert 22 22 21 1 0,  -- 75: IdxInsert
  .rewind 22 99 0 0 0,  -- 76: Rewind
  .column 22 0 23 0 0,  -- 77: Column
  .isNull 23 98 0 0 0,  -- 78: IsNull
  .seekGE 21 98 23 1 0,  -- 79: SeekGE
  .idxGT 21 98 23 1 0,  -- 80: IdxGT
  .deferredSeek 21 0 7 "[1,0]" 0,  -- 81: DeferredSeek
  .column 21 0 22 0 0,  -- 82: Column
  .ifNot 22 98 1 0 0,  -- 83: IfNot
  .column 21 0 22 0 0,  -- 84: Column
  .column 9 0 21 0 0,  -- 85: Column
  .lt 21 90 22 "RTRIM-8" 81,  -- 86: Lt
  .column 9 0 25 0 0,  -- 87: Column
  .add 6 25 21 0 0,  -- 88: Add
  .le 21 95 22 "RTRIM-8" 65,  -- 89: Le
  .column 21 0 22 0 0,  -- 90: Column
  .ifNot 22 98 1 0 0,  -- 91: IfNot
  .column 21 0 22 0 0,  -- 92: Column
  .column 9 0 21 0 0,  -- 93: Column
  .ne 22 98 21 "RTRIM-8" 81,  -- 94: Ne
  .idxRowid 21 19 0 0 0,  -- 95: IdxRowid
  .rowSetTest 18 98 19 -1 0,  -- 96: RowSetTest
  .gosub 17 100 0 0 0,  -- 97: Gosub
  .next 22 77 0 0 0,  -- 98: Next
  .goto 0 115 0 0 0,  -- 99: Goto
  .column 21 0 21 0 0,  -- 100: Column
  .column 9 0 25 0 0,  -- 101: Column
  .lt 25 106 21 "RTRIM-8" 81,  -- 102: Lt
  .column 9 0 26 0 0,  -- 103: Column
  .add 6 26 25 0 0,  -- 104: Add
  .le 25 111 21 "RTRIM-8" 65,  -- 105: Le
  .column 21 0 21 0 0,  -- 106: Column
  .ifNot 21 114 1 0 0,  -- 107: IfNot
  .column 21 0 21 0 0,  -- 108: Column
  .column 9 0 25 0 0,  -- 109: Column
  .ne 21 114 25 "RTRIM-8" 81,  -- 110: Ne
  .column 21 0 15 0 0,  -- 111: Column
  .clrSubtype 15 0 0 0 0,  -- 112: ClrSubtype
  .decrJumpZero 16 117 0 0 0,  -- 113: DecrJumpZero
  .return 17 100 0 0 0,  -- 114: Return
  .next 9 43 0 0 1,  -- 115: Next
  .next 8 42 0 0 1,  -- 116: Next
  .return 14 34 1 0 0,  -- 117: Return
  .copy 15 13 0 0 0,  -- 118: Copy
  .isNull 13 141 0 0 0,  -- 119: IsNull
  .seekGE 20 141 13 1 0,  -- 120: SeekGE
  .column 4 0 27 0 0,  -- 121: Column
  .add 6 27 13 0 0,  -- 122: Add
  .isNull 13 141 0 0 0,  -- 123: IsNull
  .idxGT 20 141 13 1 0,  -- 124: IdxGT
  .deferredSeek 20 0 3 "[1,0]" 0,  -- 125: DeferredSeek
  .column 20 0 27 0 0,  -- 126: Column
  .column 5 0 28 0 0,  -- 127: Column
  .lt 28 132 27 "BINARY-8" 81,  -- 128: Lt
  .column 5 0 29 0 0,  -- 129: Column
  .add 6 29 28 0 0,  -- 130: Add
  .le 28 137 27 "BINARY-8" 65,  -- 131: Le
  .column 20 0 27 0 0,  -- 132: Column
  .ifNot 27 140 1 0 0,  -- 133: IfNot
  .column 20 0 27 0 0,  -- 134: Column
  .column 5 0 28 0 0,  -- 135: Column
  .ne 27 140 28 "BINARY-8" 81,  -- 136: Ne
  .idxRowid 20 12 0 0 0,  -- 137: IdxRowid
  .rowSetTest 11 140 12 0 0,  -- 138: RowSetTest
  .gosub 10 397 0 0 0,  -- 139: Gosub
  .next 20 124 0 0 0,  -- 140: Next
  .reopenIdx 20 5 0 "k(2,,)" 2,  -- 141: ReopenIdx
  .noop 0 31 0 0 0,  -- 142: Noop
  .noop 0 0 0 0 0,  -- 143: Noop
  .openEphemeral 23 1 0 "k(1,B)" 0,  -- 144: OpenEphemeral
  .column 4 0 28 0 0,  -- 145: Column
  .makeRecord 28 1 29 "A" 0,  -- 146: MakeRecord
  .idxInsert 23 29 28 1 0,  -- 147: IdxInsert
  .rewind 23 396 0 0 0,  -- 148: Rewind
  .column 23 0 30 0 0,  -- 149: Column
  .isNull 30 395 0 0 0,  -- 150: IsNull
  .seekGE 20 395 30 1 0,  -- 151: SeekGE
  .idxGT 20 395 30 1 0,  -- 152: IdxGT
  .deferredSeek 20 0 3 "[1,0]" 0,  -- 153: DeferredSeek
  .column 20 0 29 0 0,  -- 154: Column
  .column 5 0 28 0 0,  -- 155: Column
  .lt 28 160 29 "BINARY-8" 81,  -- 156: Lt
  .column 5 0 32 0 0,  -- 157: Column
  .add 6 32 28 0 0,  -- 158: Add
  .le 28 165 29 "BINARY-8" 65,  -- 159: Le
  .column 20 0 29 0 0,  -- 160: Column
  .ifNot 29 395 1 0 0,  -- 161: IfNot
  .column 20 0 29 0 0,  -- 162: Column
  .column 5 0 28 0 0,  -- 163: Column
  .ne 29 395 28 "BINARY-8" 81,  -- 164: Ne
  .beginSubrtn 0 33 0 0 0,  -- 165: BeginSubrtn
  .once 0 390 0 0 0,  -- 166: Once
  .integer 0 34 0 0 0,  -- 167: Integer
  .integer 1 35 0 0 0,  -- 168: Integer
  .openRead 10 3 0 1 0,  -- 169: OpenRead
  .openRead 11 4 0 1 0,  -- 170: OpenRead
  .rewind 10 390 0 0 0,  -- 171: Rewind
  .null 0 37 0 0 0,  -- 172: Null
  .integer 385 36 0 0 0,  -- 173: Integer
  .reopenIdx 24 5 0 "k(2,,)" 0,  -- 174: ReopenIdx
  .column 10 0 39 0 0,  -- 175: Column
  .isNull 39 187 0 0 0,  -- 176: IsNull
  .seekGE 24 187 39 1 0,  -- 177: SeekGE
  .column 10 0 32 0 0,  -- 178: Column
  .add 6 32 39 0 0,  -- 179: Add
  .isNull 39 187 0 0 0,  -- 180: IsNull
  .idxGT 24 187 39 1 0,  -- 181: IdxGT
  .deferredSeek 24 0 11 "[1,0]" 0,  -- 182: DeferredSeek
  .idxRowid 24 38 0 0 0,  -- 183: IdxRowid
  .rowSetTest 37 186 38 0 0,  -- 184: RowSetTest
  .gosub 36 386 0 0 0,  -- 185: Gosub
  .next 24 181 0 0 0,  -- 186: Next
  .reopenIdx 24 5 0 "k(2,,)" 2,  -- 187: ReopenIdx
  .beginSubrtn 0 41 0 "subrtnsig:6,A" 0,  -- 188: BeginSubrtn
  .once 0 372 42 0 0,  -- 189: Once
  .openEphemeral 25 1 0 "k(1,B)" 0,  -- 190: OpenEphemeral
  .blob 10000 42 0 0 0,  -- 191: Blob
  .openRead 14 3 0 1 0,  -- 192: OpenRead
  .openRead 15 3 0 1 0,  -- 193: OpenRead
  .openRead 13 4 0 1 0,  -- 194: OpenRead
  .ifEmpty 13 371 0 0 0,  -- 195: IfEmpty
  .rewind 14 371 0 0 0,  -- 196: Rewind
  .rewind 15 371 0 0 0,  -- 197: Rewind
  .null 0 44 0 0 0,  -- 198: Null
  .integer 303 43 0 0 0,  -- 199: Integer
  .reopenIdx 26 5 0 "k(2,,)" 0,  -- 200: ReopenIdx
  .column 15 0 46 0 0,  -- 201: Column
  .isNull 46 273 0 0 0,  -- 202: IsNull
  .seekGE 26 273 46 1 0,  -- 203: SeekGE
  .column 15 0 32 0 0,  -- 204: Column
  .add 6 32 46 0 0,  -- 205: Add
  .isNull 46 273 0 0 0,  -- 206: IsNull
  .idxGT 26 273 46 1 0,  -- 207: IdxGT
  .deferredSeek 26 0 13 "[1,0]" 0,  -- 208: DeferredSeek
  .column 26 0 32 0 0,  -- 209: Column
  .beginSubrtn 0 48 0 0 0,  -- 210: BeginSubrtn
  .null 0 49 49 0 0,  -- 211: Null
  .initCoroutine 50 239 213 0 0,  -- 212: InitCoroutine
  .column 26 0 53 0 0,  -- 213: Column
  .column 14 0 55 0 0,  -- 214: Column
  .integer 1 54 0 0 0,  -- 215: Integer
  .ge 55 218 53 "BINARY-8" 65,  -- 216: Ge
  .zeroOrNull 53 54 55 0 0,  -- 217: ZeroOrNull
  .column 14 0 57 0 0,  -- 218: Column
  .add 6 57 56 0 0,  -- 219: Add
  .integer 1 55 0 0 0,  -- 220: Integer
  .le 56 223 53 "BINARY-8" 65,  -- 221: Le
  .zeroOrNull 53 55 56 0 0,  -- 222: ZeroOrNull
  .and 55 54 52 0 0,  -- 223: And
  .column 26 0 55 0 0,  -- 224: Column
  .null 0 54 0 0 0,  -- 225: Null
  .column 26 0 56 0 0,  -- 226: Column
  .bitAnd 56 56 57 0 0,  -- 227: BitAnd
  .column 14 0 58 0 0,  -- 228: Column
  .bitAnd 57 58 57 0 0,  -- 229: BitAnd
  .eq 56 233 58 "BINARY-8" 65,  -- 230: Eq
  .isNull 57 235 0 0 0,  -- 231: IsNull
  .goto 0 234 0 0 0,  -- 232: Goto
  .integer 1 54 0 0 0,  -- 233: Integer
  .addImm 54 0 0 0 0,  -- 234: AddImm
  .and 54 55 53 0 0,  -- 235: And
  .or 53 52 51 0 0,  -- 236: Or
  .yield 50 0 0 0 0,  -- 237: Yield
  .endCoroutine 50 0 0 0 0,  -- 238: EndCoroutine
  .integer 1 59 0 0 0,  -- 239: Integer
  .openRead 17 3 0 1 0,  -- 240: OpenRead
  .initCoroutine 50 0 213 0 0,  -- 241: InitCoroutine
  .yield 50 259 0 0 0,  -- 242: Yield
  .rewind 17 259 0 0 0,  -- 243: Rewind
  .column 26 0 60 0 0,  -- 244: Column
  .column 17 0 61 0 0,  -- 245: Column
  .lt 61 250 60 "BINARY-8" 81,  -- 246: Lt
  .column 17 0 62 0 0,  -- 247: Column
  .add 6 62 61 0 0,  -- 248: Add
  .le 61 255 60 "BINARY-8" 65,  -- 249: Le
  .column 26 0 60 0 0,  -- 250: Column
  .ifNot 60 257 1 0 0,  -- 251: IfNot
  .column 26 0 60 0 0,  -- 252: Column
  .column 17 0 61 0 0,  -- 253: Column
  .ne 60 257 61 "BINARY-8" 81,  -- 254: Ne
  .column 26 0 49 0 0,  -- 255: Column
  .decrJumpZero 59 259 0 0 0,  -- 256: DecrJumpZero
  .next 17 244 0 0 1,  -- 257: Next
  .goto 0 242 0 0 0,  -- 258: Goto
  .return 48 211 1 0 0,  -- 259: Return
  .lt 49 264 32 "BINARY-8" 81,  -- 260: Lt
  .column 14 0 63 0 0,  -- 261: Column
  .add 6 63 47 0 0,  -- 262: Add
  .le 47 269 32 "BINARY-8" 65,  -- 263: Le
  .column 26 0 32 0 0,  -- 264: Column
  .ifNot 32 272 1 0 0,  -- 265: IfNot
  .column 26 0 32 0 0,  -- 266: Column
  .column 14 0 47 0 0,  -- 267: Column
  .ne 32 272 47 "BINARY-8" 81,  -- 268: Ne
  .idxRowid 26 45 0 0 0,  -- 269: IdxRowid
  .rowSetTest 44 272 45 0 0,  -- 270: RowSetTest
  .gosub 43 304 0 0 0,  -- 271: Gosub
  .next 26 207 0 0 0,  -- 272: Next
  .reopenIdx 26 5 0 "k(2,,)" 2,  -- 273: ReopenIdx
  .noop 0 65 0 0 0,  -- 274: Noop
  .noop 0 0 0 0 0,  -- 275: Noop
  .openEphemeral 27 1 0 "k(1,B)" 0,  -- 276: OpenEphemeral
  .column 15 0 47 0 0,  -- 277: Column
  .makeRecord 47 1 63 "A" 0,  -- 278: MakeRecord
  .idxInsert 27 63 47 1 0,  -- 279: IdxInsert
  .rewind 27 303 0 0 0,  -- 280: Rewind
  .column 27 0 64 0 0,  -- 281: Column
  .isNull 64 302 0 0 0,  -- 282: IsNull
  .seekGE 26 302 64 1 0,  -- 283: SeekGE
  .idxGT 26 302 64 1 0,  -- 284: IdxGT
  .deferredSeek 26 0 13 "[1,0]" 0,  -- 285: DeferredSeek
  .column 26 0 63 0 0,  -- 286: Column
  .ifNot 63 302 1 0 0,  -- 287: IfNot
  .column 26 0 63 0 0,  -- 288: Column
  .gosub 48 211 0 0 0,  -- 289: Gosub
  .lt 49 294 63 "BINARY-8" 81,  -- 290: Lt
  .column 14 0 66 0 0,  -- 291: Column
  .add 6 66 47 0 0,  -- 292: Add
  .le 47 299 63 "BINARY-8" 65,  -- 293: Le
  .column 26 0 63 0 0,  -- 294: Column
  .ifNot 63 302 1 0 0,  -- 295: IfNot
  .column 26 0 63 0 0,  -- 296: Column
  .column 14 0 47 0 0,  -- 297: Column
  .ne 63 302 47 "BINARY-8" 81,  -- 298: Ne
  .idxRowid 26 45 0 0 0,  -- 299: IdxRowid
  .rowSetTest 44 302 45 -1 0,  -- 300: RowSetTest
  .gosub 43 304 0 0 0,  -- 301: Gosub
  .next 27 281 0 0 0,  -- 302: Next
  .goto 0 369 0 0 0,  -- 303: Goto
  .column 26 0 47 0 0,  -- 304: Column
  .beginSubrtn 0 67 0 0 0,  -- 305: BeginSubrtn
  .null 0 68 68 0 0,  -- 306: Null
  .initCoroutine 69 334 308 0 0,  -- 307: InitCoroutine
  .column 26 0 72 0 0,  -- 308: Column
  .column 14 0 74 0 0,  -- 309: Column
  .integer 1 73 0 0 0,  -- 310: Integer
  .ge 74 313 72 "BINARY-8" 65,  -- 311: Ge
  .zeroOrNull 72 73 74 0 0,  -- 312: ZeroOrNull
  .column 14 0 76 0 0,  -- 313: Column
  .add 6 76 75 0 0,  -- 314: Add
  .integer 1 74 0 0 0,  -- 315: Integer
  .le 75 318 72 "BINARY-8" 65,  -- 316: Le
  .zeroOrNull 72 74 75 0 0,  -- 317: ZeroOrNull
  .and 74 73 71 0 0,  -- 318: And
  .column 26 0 74 0 0,  -- 319: Column
  .null 0 73 0 0 0,  -- 320: Null
  .column 26 0 75 0 0,  -- 321: Column
  .bitAnd 75 75 76 0 0,  -- 322: BitAnd
  .column 14 0 77 0 0,  -- 323: Column
  .bitAnd 76 77 76 0 0,  -- 324: BitAnd
  .eq 75 328 77 "BINARY-8" 65,  -- 325: Eq
  .isNull 76 330 0 0 0,  -- 326: IsNull
  .goto 0 329 0 0 0,  -- 327: Goto
  .integer 1 73 0 0 0,  -- 328: Integer
  .addImm 73 0 0 0 0,  -- 329: AddImm
  .and 73 74 72 0 0,  -- 330: And
  .or 72 71 70 0 0,  -- 331: Or
  .yield 69 0 0 0 0,  -- 332: Yield
  .endCoroutine 69 0 0 0 0,  -- 333: EndCoroutine
  .integer 1 78 0 0 0,  -- 334: Integer
  .openRead 17 3 0 1 0,  -- 335: OpenRead
  .initCoroutine 69 0 308 0 0,  -- 336: InitCoroutine
  .yield 69 354 0 0 0,  -- 337: Yield
  .rewind 17 354 0 0 0,  -- 338: Rewind
  .column 26 0 79 0 0,  -- 339: Column
  .column 17 0 80 0 0,  -- 340: Column
  .lt 80 345 79 "BINARY-8" 81,  -- 341: Lt
  .column 17 0 81 0 0,  -- 342: Column
  .add 6 81 80 0 0,  -- 343: Add
  .le 80 350 79 "BINARY-8" 65,  -- 344: Le
  .column 26 0 79 0 0,  -- 345: Column
  .ifNot 79 352 1 0 0,  -- 346: IfNot
  .column 26 0 79 0 0,  -- 347: Column
  .column 17 0 80 0 0,  -- 348: Column
  .ne 79 352 80 "BINARY-8" 81,  -- 349: Ne
  .column 26 0 68 0 0,  -- 350: Column
  .decrJumpZero 78 354 0 0 0,  -- 351: DecrJumpZero
  .next 17 339 0 0 1,  -- 352: Next
  .goto 0 337 0 0 0,  -- 353: Goto
  .return 67 306 1 0 0,  -- 354: Return
  .lt 68 359 47 "BINARY-8" 81,  -- 355: Lt
  .column 14 0 82 0 0,  -- 356: Column
  .add 6 82 66 0 0,  -- 357: Add
  .le 66 364 47 "BINARY-8" 65,  -- 358: Le
  .column 26 0 47 0 0,  -- 359: Column
  .ifNot 47 368 1 0 0,  -- 360: IfNot
  .column 26 0 47 0 0,  -- 361: Column
  .column 14 0 66 0 0,  -- 362: Column
  .ne 47 368 66 "BINARY-8" 81,  -- 363: Ne
  .column 26 0 83 0 0,  -- 364: Column
  .makeRecord 83 1 66 "A" 0,  -- 365: MakeRecord
  .idxInsert 25 66 83 1 0,  -- 366: IdxInsert
  .filterAdd 42 0 83 1 0,  -- 367: FilterAdd
  .return 43 304 0 0 0,  -- 368: Return
  .next 15 198 0 0 1,  -- 369: Next
  .next 14 197 0 0 1,  -- 370: Next
  .nullRow 25 0 0 0 0,  -- 371: NullRow
  .return 41 189 1 0 0,  -- 372: Return
  .rewind 25 385 0 0 0,  -- 373: Rewind
  .column 25 0 40 0 0,  -- 374: Column
  .isNull 40 384 0 0 0,  -- 375: IsNull
  .seekGE 24 384 40 1 0,  -- 376: SeekGE
  .idxGT 24 384 40 1 0,  -- 377: IdxGT
  .deferredSeek 24 0 11 "[1,0]" 0,  -- 378: DeferredSeek
  .column 24 0 84 0 0,  -- 379: Column
  .ifNot 84 384 1 0 0,  -- 380: IfNot
  .idxRowid 24 38 0 0 0,  -- 381: IdxRowid
  .rowSetTest 37 384 38 -1 0,  -- 382: RowSetTest
  .gosub 36 386 0 0 0,  -- 383: Gosub
  .next 25 374 0 0 0,  -- 384: Next
  .goto 0 389 0 0 0,  -- 385: Goto
  .integer 1 34 0 0 0,  -- 386: Integer
  .decrJumpZero 35 390 0 0 0,  -- 387: DecrJumpZero
  .return 36 386 0 0 0,  -- 388: Return
  .next 10 172 0 0 1,  -- 389: Next
  .return 33 166 1 0 0,  -- 390: Return
  .if 34 395 1 0 0,  -- 391: If
  .idxRowid 20 12 0 0 0,  -- 392: IdxRowid
  .rowSetTest 11 395 12 -1 0,  -- 393: RowSetTest
  .gosub 10 397 0 0 0,  -- 394: Gosub
  .next 23 149 0 0 0,  -- 395: Next
  .goto 0 413 0 0 0,  -- 396: Goto
  .column 20 0 28 0 0,  -- 397: Column
  .column 5 0 86 0 0,  -- 398: Column
  .lt 86 403 28 "BINARY-8" 81,  -- 399: Lt
  .column 5 0 87 0 0,  -- 400: Column
  .add 6 87 86 0 0,  -- 401: Add
  .le 86 408 28 "BINARY-8" 65,  -- 402: Le
  .column 20 0 28 0 0,  -- 403: Column
  .ifNot 28 412 1 0 0,  -- 404: IfNot
  .column 20 0 28 0 0,  -- 405: Column
  .column 5 0 86 0 0,  -- 406: Column
  .ne 28 412 86 "BINARY-8" 81,  -- 407: Ne
  .column 20 0 88 0 0,  -- 408: Column
  .makeRecord 88 1 86 "A" 0,  -- 409: MakeRecord
  .idxInsert 19 86 88 1 0,  -- 410: IdxInsert
  .filterAdd 9 0 88 1 0,  -- 411: FilterAdd
  .return 10 397 0 0 0,  -- 412: Return
  .next 5 30 0 0 1,  -- 413: Next
  .next 4 29 0 0 1,  -- 414: Next
  .nullRow 19 0 0 0 0,  -- 415: NullRow
  .return 8 21 1 0 0,  -- 416: Return
  .rewind 19 429 0 0 0,  -- 417: Rewind
  .column 19 0 7 0 0,  -- 418: Column
  .isNull 7 428 0 0 0,  -- 419: IsNull
  .seekGE 18 428 7 1 0,  -- 420: SeekGE
  .idxGT 18 428 7 1 0,  -- 421: IdxGT
  .deferredSeek 18 0 0 "[1,0]" 0,  -- 422: DeferredSeek
  .column 18 0 89 0 0,  -- 423: Column
  .ifNot 89 428 1 0 0,  -- 424: IfNot
  .idxRowid 18 3 0 0 0,  -- 425: IdxRowid
  .rowSetTest 2 428 3 -1 0,  -- 426: RowSetTest
  .gosub 1 430 0 0 0,  -- 427: Gosub
  .next 19 418 0 0 0,  -- 428: Next
  .goto 0 433 0 0 0,  -- 429: Goto
  .column 18 0 90 0 0,  -- 430: Column
  .resultRow 90 1 0 0 0,  -- 431: ResultRow
  .return 1 430 0 0 0,  -- 432: Return
  .next 1 4 0 0 1,  -- 433: Next
  .halt 0 0 0 0 0,  -- 434: Halt
  .transaction 0 0 33 1 1,  -- 435: Transaction
  .integer 1 6 0 0 0,  -- 436: Integer
  .goto 0 1 0 0 0  -- 437: Goto
]

/-- Main termination theorem: program terminates for any database -/
theorem program_terminates (db : Database) :
    ∃ n : Nat, (runBounded program (mkInitialState db) n).status ≠ .running := by
  sorry

end Sqlite3Lean.Query000147

> module SExpr where

> import Text.PrettyPrint.HughesPJ 
> import PrintBasics

----------------------------------

> data SExpr 
>  = SNode {name :: String, children :: [SExpr]}
>  | SLeaf {val :: String}
>    deriving (Show, Eq)



> instance PrettyPrintable SExpr where
>   pp (SLeaf s) = text s
>   pp (SNode n cs) = text ("<< " ++ n) $$ nest 2 (foldr ($$) empty $ map pp cs) 


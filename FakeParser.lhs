> module FakeParser(SExpr(..), parseFile, parseInput) where

> -- import IO
> import System
> import Char
> import Monad
> import Text.ParserCombinators.Parsec

> import PrintBasics
> import SExpr


------------------------------------

> p_term = wsp >> (p_expr <|> p_name)

> p_name = fmap SLeaf 
>        $ many 
>        $ satisfy 
>        $ \c -> c `notElem` " \t(),"

> p_expr
>  = do 
>      char 's'
>      char '('
>      SLeaf n <- p_name 
>      args    <- p_args
>      char ')'
>      return $ SNode n args

> p_args
>  = many $ wsp >> char ',' >> p_term 

> wsp = many (satisfy isSpace) 


> run p s = parse p "" s 
> t1 = " s(:class, :Foo, nil, s(:scope, s(:defn, :main, s(:args), s(:scope, s(:block, s(:lasgn, :x, s(:lit, 3)), s(:lasgn, :y, s(:call, s(:lvar, :x), :+, s(:arglist, s(:lvar, :y))))))))) "

> t2 = print $ run p_name "foo"
> t3 = print $ run p_name ":foo"
> t4 = print $ run p_args ",:foo"
> t5 = print $ run p_args ",:foo , :bar"
> t6 = print $ run p_expr "s(:foo)" 
> t7 = print $ run p_expr "s(:foo, :bar)" 

<> t5 = print $ run p_args ",:foo, bar"
<> t6 = print $ run p_expr ":foo"
<> t7 = print $ run p_sym ":foo"

> tp1 n = test $ ("0" ++) $ unwords $ replicate n "* y.foo(x)"

--------------------

> parseInput s
>  = do 
>       writeFile input s
>       parseFile input 
>    where
>      input = "foo1"

> parseFile input 
>  = do 
>       system $ unwords ["ruby_parse", input, ">", output]
>       inp <- readFile output
>       let clean_inp = unlines $ reverse $ drop 4 $ reverse $ lines inp
>       case parse p_term "" inp of
>         Right x -> return x
>         Left y  -> fail ("No parse: " ++ show y) 
>    where
>      output = "foo2"

> test s = parseInput s >>= putStr . pretty_print 

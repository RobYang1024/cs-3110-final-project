open OUnit2
open Dictionary
open Comparison

let emp_file = FileDict.empty

let se_dict = FileDict.insert "a" [1] emp_file
let de_dict = FileDict.(empty |> insert "a" [1;2] |> insert "b" [1;3])
let emp_e_dict = FileDict.(empty |> insert "a" [] |> insert "b" [7;4]
                           |> insert "c" [4;8;13])

let def_p_comp = FileDict.(empty |> insert "a" [1;2] |> insert "b" [1])
let des_p_comp = FileDict.(empty |> insert "a" [1] |> insert "b" [1;3])
let emp_e_f_p_comp = FileDict.(empty |> insert "a" [] |> insert "b" []
                               |> insert "c" [])
let emp_e_s_p_comp = FileDict.(empty |> insert "a" [] |> insert "b" [7;4]
                               |> insert "c" [4])
let emp_e_t_p_comp = FileDict.(empty |> insert "a" [] |> insert "b" [4]
                               |> insert "c" [4;8;13])


let emp_comp = CompDict.empty
let se_comp = CompDict.(insert "a" se_dict empty)
let def_comp = CompDict.(insert "a" def_p_comp empty)
let de_comp = CompDict.insert "b" des_p_comp def_comp
let emp_e_comp = CompDict.(empty |> insert "a" emp_e_f_p_comp
                           |> insert "b" emp_e_s_p_comp
                           |> insert "c" emp_e_t_p_comp)

let tests = [
  "empty int" >:: (fun _ -> assert_equal [] (intersection [] []));
  "single lists uneq" >:: (fun _ -> assert_equal [] (intersection [1] [2]));
  "single lists eq" >:: (fun _ -> assert_equal [1] (intersection [1] [1]));
  "diff order" >:: (fun _ -> assert_equal [1;2] ((intersection [1;2] [2;1]) |>
                                                 List.sort Pervasives.compare));
  "simp case" >:: (fun _ -> assert_equal [1;2] ((intersection [3;1;2] [2;1]) |>
                                                List.sort Pervasives.compare));
  "long case" >:: (fun _ -> assert_equal [41;20;7;53]
  (intersection [82;23;46;93;41;20;47;7;84;53] [80;42;41;53;72;7;20;100]));

  "empty file" >:: (fun _ -> assert_equal emp_file
                       (make_pair_comp "" [] emp_comp));
  "single entry" >:: (fun _ -> assert_equal se_dict
                         (make_pair_comp "a" [("a",[1])] emp_comp));
  "double entry first" >:: (fun _ -> assert_equal def_p_comp
  (make_pair_comp "a" (FileDict.to_list de_dict) emp_comp));
  "double entry second" >:: (fun _ -> assert_equal des_p_comp
  (make_pair_comp "b" (FileDict.to_list de_dict) emp_comp));
  "empty entry in file" >:: (fun _ -> assert_equal emp_e_s_p_comp
  (make_pair_comp "b" (FileDict.to_list emp_e_dict) emp_comp));
  "using comp_dict value" >:: (fun _ -> assert_equal des_p_comp
  (make_pair_comp "b" (FileDict.to_list de_dict) def_comp));


  "empty comp" >:: (fun _ -> assert_equal emp_comp
                       (compare emp_file));
  "single entry comp" >:: (fun _ -> assert_equal se_comp
                       (compare se_dict));
  "double entry comp" >:: (fun _ -> assert_equal de_comp
                              (compare de_dict));
  "empty entry comp" >:: (fun _ -> assert_equal emp_e_comp
                             (compare emp_e_dict));

  "empty sim" >:: (fun _ -> assert_equal []
                      (create_sim_list emp_comp));
  "single entry sim" >:: (fun _ -> assert_equal []
                              (create_sim_list se_comp));
  "double entry sim" >:: (fun _ -> assert_equal ["a";"b"]
                              (create_sim_list de_comp));
  "empty entry sim" >:: (fun _ -> assert_equal ["b"]
                              (create_sim_list emp_e_comp));

]

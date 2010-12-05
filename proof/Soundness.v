Require Import Ascii.
Require Import ListUtil Object MultiByte SerializeSpec Prefix ProofUtil.

Definition Soundness obj1 x : Prop := forall obj2,
  Serialized obj1 x ->
  Serialized obj2 x ->
  Valid obj1 ->
  Valid obj2 ->
  obj1 = obj2.

Ltac straightfoward :=
  unfold Soundness;
  intros obj2 Hs1 Hs2 V1 V2;
  inversion Hs2;
  reflexivity.

Lemma  soundness_nil:
  Soundness Nil ["192"].
Proof.
straightfoward.
Qed.

Lemma soundness_true :
  Soundness (Bool true) ["195"].
Proof.
straightfoward.
Qed.

Lemma soundness_false :
  Soundness (Bool false) ["194"].
Proof.
straightfoward.
Qed.


(*Lemma soundness_array16_nil :
  Serialized (Array16 []) ["220"; "000"; "000"] ->
  Soundness (Array16 []) ["220"; "000"; "000"].
Proof.
unfold Soundness; intros.
inversion H0.
 reflexivity.

 apply ascii16_not_O in H8.
  contradiction.

  split.
   apply length_lt_O.

   rewrite <- H7 in *.
   inversion H2.
   assumption.
Qed.

Lemma soundness_array16_cons: forall x xs t1 t2 s1 s2 y ys,
  (t1, t2) = ascii16_of_nat (length xs) ->
  (s1, s2) = ascii16_of_nat (length (x :: xs)) ->
  Serialized x y ->
  (Serialized x y -> Soundness x y) ->
  Serialized (Array16 xs) ("220" :: t1 :: t2 :: ys) ->
  (Serialized (Array16 xs) ("220" :: t1 :: t2 :: ys) ->
    Soundness (Array16 xs) ("220" :: t1 :: t2 :: ys)) ->
  Serialized (Array16 (x :: xs)) ("220" :: s1 :: s2 :: y ++ ys) ->
  Soundness (Array16 (x :: xs)) ("220" :: s1 :: s2 :: y ++ ys).
Proof.
Admitted.
(*intros.
generalize H1 H3; intros Hs1 Hs'1.
apply H2 in H1.
apply H4 in H3.
unfold Soundness in *.
intros.
inversion H6.
 rewrite <- H11, <- H12 in *.
 apply ascii16_not_O in H0.
  contradiction.

  split.
   apply length_lt_O.

   inversion H7.
   auto.

 rewrite <- H13 in *; clear H13.
 inversion H7.
 inversion H8.
 apply prefix in Hs1.
 apply prefix in Hs'1.
 unfold Prefix in *.

 generalize H15 H16; intros Hs2 Hs'2.
 apply (Hs1 _ _ ys ys0) in H15; auto.
 rewrite H15 in *; clear H15.
 apply H1 in Hs2; auto.
 rewrite Hs2.
 apply app_same in H11.
 rewrite H11 in *; clear H11.

 assert ((t0,t3) = (t1,t2)).
  rewrite H, H12.
  apply (varray16_inv2  _ x0 x); auto.
  rewrite <- H0, <- H14.
  reflexivity.

  inversion H11.
  rewrite H26, H27 in *.
  apply H3 in Hs'2; auto.
  inversion Hs'2.
  reflexivity.
Qed.*)
*)

Hint Resolve
  soundness_nil soundness_true soundness_false
  : soundness.

Lemma soundness_intro: forall obj x,
  (Serialized obj x -> Soundness obj x)->
  Soundness obj x.
Proof.
unfold Soundness.
intros.
apply H in H1; auto.
Qed.

Lemma soundness : forall obj1 x,
  Soundness obj1 x.
Proof.
intros.
apply soundness_intro.
intro.
pattern obj1,x.
apply Serialized_ind; intros; auto with soundness.
Admitted.

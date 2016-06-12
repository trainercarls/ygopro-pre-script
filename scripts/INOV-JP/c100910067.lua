--王者の調和
--King's Synchro
--Script by nekrozar
function c100910067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c100910067.condition)
	e1:SetOperation(c100910067.activate)
	c:RegisterEffect(e1)
end
function c100910067.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsFaceup() and tc:IsControler(tp) and tc:IsType(TYPE_SYNCHRO)
end
function c100910067.filter1(c,e,tp,lv)
	local rlv=c:GetLevel()-lv
	return rlv>0 and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c100910067.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,rlv)
end
function c100910067.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	return rlv==0 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c100910067.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if Duel.NegateAttack() and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c100910067.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetLevel())
		and tc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(100910067,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c100910067.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLevel())
		local lv=g1:GetFirst():GetLevel()-tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c100910067.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
		g2:AddCard(tc)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		g1:GetFirst():CompleteProcedure()
	end
end

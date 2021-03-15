<template>
  <div class="operatorsList">
    <h2 class="sectionHeader">
      Operators
    </h2>
    <div v-for="(operator, opIndex) in operators" :key="opIndex" class="operator">
      <div class="operator__indicator __indicator" :class="indicatorColor(operator)"/>
      <div class="operator__name">
        {{ operator.firstName }} {{ operator.lastName }}
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {

  data () {
    return {
      operators: []
    }
  },
  created () {
    console.log('Operator List Created')
    this.addOperatorsListener(this.receiveOperators)
    this.addOperatorChangeListener(this.receiveOperatorChange)
  },

  methods: {
    ...mapActions('socketx', [
      'addOperatorsListener',
      'addOperatorChangeListener'
    ]),

    receiveOperators (operators) {
      this.operators = operators
    },

    receiveOperatorChange (operator) {
      if(this.isBlank(operator.status)) {
        this.operators = this.operators.filter(op => operator.id != op.id)
      } else {
        const foundOperator = this.operators.find(op => op.id == operator.id)
        if(this.isBlank(foundOperator)) { return }
        foundOperator.status = operator.status
      }
    },

    indicatorColor (op) {
      if (op.status == 'available') { return '--green' }
      else if (op.status == 'idle') { return '--yellow' }
      else if (op.status == 'away') { return '--red' }
    }
  }
}
</script>

<style lang="scss">
.operator {
  display: flex;
  align-items: center;
}
.__indicator {
  width: 11px;
  height: 11px;
  border-radius: 50%;
  margin-right: 8px;
}
</style>

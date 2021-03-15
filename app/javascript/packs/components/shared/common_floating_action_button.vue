<template>
  <button class="commonFloatingActionButton" @click.prevent="primaryAction">
    +
  </button>
</template>

<script>

export default {
  props: {
    primaryActionCallback: { default () { return true }, type: Function }
  },
  methods: {
    primaryAction () {
      try {
        return this.primaryActionCallback()
      } catch(e) {
        return true
      }
    }
  }
}
</script>

<style scoped lang="scss">
@import '~@styles/variables.scss';

.commonFloatingActionButton{
  bottom: 30px;
  right: 30px;
  position: absolute;
  background-color: $primaryHighlight;
  width:60px;
  height:60px;
  border-radius:100%;
  background: $primaryHighlight;
  border:none;
  outline:none;
  color:#FFF;
  font-size:36px;
  box-shadow: 0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23);
  transition:.3s;
  -webkit-tap-highlight-color: rgba(0,0,0,0);
}
.commonFloatingActionButton:focus {
  transform:scale(1.1);
  transform:rotate(45deg);
  -ms-transform: rotate(45deg);
  -webkit-transform: rotate(45deg);
}
</style>

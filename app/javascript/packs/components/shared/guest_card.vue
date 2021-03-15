<template>
  <div>
    <div class="row no-gutters">
      <div class="col-md-5 mx-auto">
        <div class="row no-gutters">
          <div class="col-sm-9">
            <img class="logo pb-3" src="/mc_logo.png">
          </div>
          <div class="col-sm-3 text-center align-center primaryHighlight px-1">
            <i class="fa fa-lg pt-3" :class="cardIcon"/>
            <br>
            {{ cardTitle }}
          </div>
        </div>
      </div>
    </div>
    <div class="row no-gutters">
      <div class="card bg-white col-md-5 mx-auto text-left border-top-primary">
        <div class="card-body">
          <slot/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    cardIcon: { default: 'fa-user', type: String },
    cardTitle: { default: '', type: String }
  }
}
</script>

<style scoped lang="scss">
@import '~@styles/variables.scss';

.logo {
  height: 70px;
}
.login-padding-top {
  padding-top: 10rem;
}
.highlighter-red {
  border: 2px solid red !important;
}
.border-top-primary {
  border-top: 7px solid $primaryHighlight;
  border-radius: 5px 0px;
}

.primaryHighlight {
  background-color: $primaryHighlight;
  border-radius: 5px 5px 0px 0px;
  color: white;
}
</style>

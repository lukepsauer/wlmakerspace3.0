/**
 * Created by nqmet on 6/23/2016.
 */
var controller = new ScrollMagic.Controller({globalSceneOptions: {triggerHook: "onEnter", duration: "200%"}});
new ScrollMagic.Scene({triggerElement: ".header-image"})
    .setTween(".header-image > div", {y: "80%", ease: Linear.easeNone})
    .addIndicators()
    .addTo(controller);

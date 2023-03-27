# deepar

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

As deepAR removes the inbuilt functionality where we pass the file path and load the selected effect, in order to achieve this functionality we have to make some changes in native code as follows"

# steps
1. ctrl + click on the "switchEffectWithSlot()" where we used.
2. now using vs code action bar go to deepar_flutter_0.0./android/src/main/java/com/deepar/ai/DeepArPlugin.java
3. In DeepArPlugin.java file search for  ' case "switchEffectWithSlot": '
4. And replace this case with following

case "switchEffectWithSlot":
                String slot = ((String) arguments.get("slot"));
                String path = ((String) arguments.get("path"));
                int face = 0;
                String targetGameObject = "";

                try {
                    face = (int) arguments.get("face");
                }catch (Exception e){
                    e.printStackTrace();
                }

                try {
                    targetGameObject = ((String) arguments.get("targetGameObject"));
                }catch (Exception e){
                    e.printStackTrace();
                }
                if (path != null && path.toLowerCase().endsWith("none") ){
                    deepAR.switchEffect(slot, getResetPath()); // reset applied effect
                    result.success("switchEffectWithSlot reset success");
                    return;
                }

                if (!targetGameObject.isEmpty()){
                    deepAR.switchEffect(slot, path, face, targetGameObject);
                }else{
                    deepAR.switchEffect(slot, path, face);
                }
                result.success("switchEffectWithSlot called successfully");
            break;

_my thoughts on ai alignment and interpretability._

In 2023, someone asked me to join their research group working on AI interpretability. At the time, I did not consider myself knowledgeable enough to do what I understood to be dissecting MLPs or other models.

Fast forward to 2025 and I came across [Situational Awareness](https://situational-awareness.ai/) by Leopold Aschenbrenner. The trajectory he describes is built on a fascinating series of arguments and conclusions that can be distilled into:

- LLMs' capabilities are advancing at an extraordinary pace
- The main constraint on growth is the availability of trillion or hundred-billion dollar clusters
- Once that scale is reached, AGI will be within reach
- This will likely trigger a rapid intelligence explosion that makes superalignment extremely difficult

This led me into a rabbit hole of reading about [AI](https://ai-2027.com), [forecasts](https://www.lesswrong.com/posts/K2D45BNxnZjdpSX2j/ai-timelines), and [AI alignment](https://www.alignmentforum.org/). I then recalled the AI interpretability research I had first encountered back in 2023, which has since grown into a much deeper and more developed field.

I am not very much an AI doomer. The x-risk from AGI seems to me to be [something blown out of proportion](https://www.lesswrong.com/w/ai-risk-skepticism). While reading alignment discussions, the thought crossed my mind: instead of worrying about alignment, why not focus on interpretability, which might in turn provide the tools needed to solve alignment? It turns out [Dario Amodei](https://www.darioamodei.com/) has expressed similar thoughts [regarding interpretability](https://www.darioamodei.com/post/the-urgency-of-interpretability), while [others strongly disagree with him](https://www.lesswrong.com/posts/PwnadG4BFjaER3MGf/interpretability-will-not-reliably-find-deceptive-ai).

The work by Anthropic is what fascinated me the most. Their research [On the Biology of a Large Language Model](https://transformer-circuits.pub/2025/attribution-graphs/biology.html) feels like an entirely new way of studying these systems. There is also work like ["Attempting to Reverse-Engineer Factual Recall on the Neuron Level"](https://www.lesswrong.com/s/hpWHhjvjn67LJ4xXX) which takes a similar direction of digging into the fine structure of model behavior. These make me feel, [Transformer Mechanistic Interpretability](https://www.neelnanda.io/mechanistic-interpretability/getting-started) will be the most rewarding in terms of AI alignment which is needed to some extent despite the x-risk being just a hype.

## The Response to Counter-Arguments

Critics argue that interpretability may not reliably detect deceptive AI, claiming that understanding a deceptive model's internals might not prevent deception if the model is sophisticated enough to hide its true goals even from interpretability tools. However, recent research on [monitor evasion](https://www.alignmentforum.org/posts/dwEgSEPxpKjz3Fw5k/claude-gpt-and-gemini-all-struggle-to-evade-monitors) shows that current models struggle to evade even simple monitoring. More importantly, evasion in and of itself does not imply seeking control - the evasion behaviors observed seem more like pattern matching or local optimization rather than strategic deception aimed at gaining power.

## Hidden Assumptions of the Alarmists

Rather than relying on conclusions based on hidden assumptions - such as the notion that every problem would be solved by an AI after the intelligence explosion - we should focus on empirical research. The "intelligence explosion solves everything" assumption is a form of magical thinking that avoids grappling with specific technical challenges. Many alignment thinkers frame their concerns rigorously, but the weak spot in their reasoning is equating intelligence with control. History shows power is rarely wielded by the “smartest,” but there is a lot more to it. Similarly, optimization pressure in current models leads to local solutions, not autonomous power-seeking. This difference between intelligence and agency should be obvious - but becomes obscure only if one treats intelligence as an abstract scalar divorced from its real-world embedding.

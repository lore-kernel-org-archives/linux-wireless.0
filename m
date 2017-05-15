Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:33940 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbdEOWFd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 18:05:33 -0400
Received: by mail-qt0-f171.google.com with SMTP id c13so48606477qtc.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 May 2017 15:05:33 -0700 (PDT)
Subject: Re: [PATCH 1/1] dt-binding: net: wireless: fix node name in the
 BCM43xx example
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kvalo@codeaurora.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
References: <20170515201356.26384-1-martin.blumenstingl@googlemail.com>
 <20170515201356.26384-2-martin.blumenstingl@googlemail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8155d0f1-aed3-fc47-4524-635067f9ee7b@broadcom.com> (sfid-20170516_000540_701181_AC01D20B)
Date: Tue, 16 May 2017 00:05:30 +0200
MIME-Version: 1.0
In-Reply-To: <20170515201356.26384-2-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-5-2017 22:13, Martin Blumenstingl wrote:
> The example in the BCM43xx documentation uses "brcmf" as node name.
> However, wireless devices should be named "wifi" instead. Fix this to

Hi Martin,

Since when is that a rule. I never got the memo and the DTC did not ever
complain to me about the naming. That being said I do not really care
and I suppose it is for the sake of consistency only.

> make sure that .dts authors can simply use the documentation as
> reference (or simply copy the node from the documentation and then
> adjust only the board specific bits).

Please feel free to add my...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> index 5dbf169cd81c..590f622188de 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> @@ -31,7 +31,7 @@ mmc3: mmc@01c12000 {
>  	non-removable;
>  	status = "okay";
>  
> -	brcmf: bcrmf@1 {
> +	brcmf: wifi@1 {
>  		reg = <1>;
>  		compatible = "brcm,bcm4329-fmac";
>  		interrupt-parent = <&pio>;
> 

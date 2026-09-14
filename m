Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71C64968F0;
	Mon, 14 Sep 2026 12:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390229; cv=none; b=PcXz/ggBnn6ulAuawx2SQXjfS4BbujzhO9X4aoFpuat5FosPQh2h5VKJoetMGxEo8V+KfV1v3YSnSKXpbZyiv8AKWj6oiBFF8G/xkzGTSjrW46cuI7t4fyZ0kE08BVBY/YMj6QPZF42Z6wWqTXwGxsnxu4AAdhNlXPhivxFDw7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390229; c=relaxed/simple;
	bh=51+QGtDrrULfWPwN+qx3nNNHE2I+SDEQHyJRI8YKgiQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PqX/wWjZJbo0HDiLTgEbMGidJ9GApC4TPnGIsBfb7ZXp87c3F5J8c9Vyq9Q7xRouej4sTbeXSyVS/z9TrYHAOsoq2rgszKn7Uqp4LkO1W0ipZ3GMooVZCnxQeCX+uj+KGW2WlsaS8l7bLZigRq9xbaARmoPmFv3S+cBsExb2lJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OsrBnctL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OsrBnctL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855C61F00902;
	Mon, 14 Sep 2026 12:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789390225;
	bh=nAHs0FwO5HirqBTAsL4xPSPoEzHJVgBNldVSVJGuM6w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=OsrBnctLlVJgJWgc+plCxEab0DY8146Qc1y8Ip+Tu/Ll3daLLQsZaHPldecXLyIdC
	 NBuC3ALG7uHJs19Qw3qJdlrLV9Ay7UVdlo7Bh8RRQ1RWDqKWUnsfOIRfQmgNVqrY8n
	 wp5SesIHJyRyNLXyA+WfzoHIpICyGsVKuLUtDzW2qWN7k7FZ7WqfxCWV5etlbIM54b
	 gVP5twM7yfOTh/ZQRqmwiVOXlFYvVhHItFHWHfKQToTY+135Kiu2uJkEBXt3uqd8VB
	 xaTqe/pxjFr4Z0TSy6ARyNJKJNSPNL/xELAfpyHHOgSHUa5LmN0goMPEqN7VffUzm7
	 9BAQr8UcOfqFw==
Subject: Re: [PATCH net-next] dt-bindings: net: Use consistent indentation in
 the example
From: netdev-bot+sashiko@kernel.org
To: krzysztof.kozlowski@oss.qualcomm.com
Cc: robin.clark@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
 jesszhan0024@gmail.com, sean@poorly.run, marijn.suijten@somainline.org,
 airlied@gmail.com, simona@ffwll.ch, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, justin.chen@broadcom.com, florian.fainelli@broadcom.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, ulli.kroll@googlemail.com,
 linusw@kernel.org, clement.leger@bootlin.com, olteanv@gmail.com,
 hkallweit1@gmail.com, linux@armlinux.org.uk, hayashi.kunihiko@socionext.com,
 mhiramat@kernel.org, nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
 shayne.chen@mediatek.com, sean.wang@mediatek.com, johannes@sipsolutions.net,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 jjohnson@kernel.org, richardcochran@gmail.com, geert+renesas@glider.be,
 magnus.damm@gmail.com, yongxing.mou@oss.qualcomm.com, rfoss@kernel.org,
 abelvesa@kernel.org, vineetha.g.jaya.kumaran@intel.com,
 claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com, elder@kernel.org,
 s-vadapalli@ti.com, rogerq@kernel.org, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 ath10k@lists.infradead.org
Date: Mon, 14 Sep 2026 12:50:22 +0000
Message-ID: <178939022208.22033.14553895731937911806@kernel.org>
In-Reply-To: <20260913122910.99457-3-krzysztof.kozlowski@oss.qualcomm.com>
References: <20260913122910.99457-3-krzysztof.kozlowski@oss.qualcomm.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] In Documentation/devicetree/bindings/net/cortina,gemini-
  ethernet.yaml the patch does more than re-indent: it deletes the whole…

--

dt-bindings: net: Use consistent indentation in the example

This reindents the DT binding examples under Documentation/devicetree/
bindings/net/ to consistent 2- or 4-space indentation so that
dt-check-style stops reporting "indent mismatch" warnings.  Twelve
binding files are touched.

> diff --git a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
> index f0b5bea2458d5..da9bc170cd543 100644
> --- a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
> +++ b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
> @@ -87,18 +87,6 @@ examples:
>      #include <dt-bindings/interrupt-controller/irq.h>
>      #include <dt-bindings/clock/cortina,gemini-clock.h>
>      #include <dt-bindings/reset/cortina,gemini-reset.h>
> -    mdio0: mdio {
> -      #address-cells = <1>;
> -      #size-cells = <0>;
> -      phy0: ethernet-phy@1 {
> -        reg = <1>;
> -        device_type = "ethernet-phy";
> -      };
> -      phy1: ethernet-phy@3 {
> -        reg = <3>;
> -        device_type = "ethernet-phy";
> -      };
> -    };

[Severity: Medium]
Is this deletion intended?  The commit message says only:

    Correct indentation in the examples to consistent 2- or 4-spaces
    indentation to fix dt-check-style warnings

Every other hunk in the series is a pure whitespace shift with the brace
nesting preserved, but here the whole mdio0 node with phy0 and phy1 is
removed and nothing is added back.

Wouldn't re-indenting the mdio0 node to 4 spaces achieve the stated goal
without dropping the example content?

> 
>      ethernet@60000000 {
>          compatible = "cortina,gemini-ethernet";
> @@ -110,28 +98,28 @@ examples:
>          ranges;
>  
>          gmac0: ethernet-port@0 {
[ ... ]
> +            phy-mode = "rgmii";
> +            phy-handle = <&phy0>;
>          };

[Severity: Medium]
Do the surviving phy-handle properties in gmac0 and gmac1 now reference
labels that no longer exist in the file?  After this patch the file
contains:

    gmac0: ethernet-port@0 {
        ...
        phy-handle = <&phy0>;
    };

    gmac1: ethernet-port@1 {
        ...
        phy-handle = <&phy1>;
    };

but there is no longer any definition of phy0 or phy1 anywhere in
cortina,gemini-ethernet.yaml, and the example no longer shows the MDIO bus
and PHY topology it used to illustrate.

If the mdio0 removal is deliberate, could it go into a separate patch that
also updates the phy-handle references?

>  
>          gmac1: ethernet-port@1 {
[ ... ]
> +            phy-mode = "rgmii";
> +            phy-handle = <&phy1>;
>          };
>      };

[ ... remaining files snipped, no comments ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260913122910.99457-3-krzysztof.kozlowski%40oss.qualcomm.com

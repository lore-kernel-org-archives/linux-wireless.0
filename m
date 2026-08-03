Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D899396572;
	Mon,  3 Aug 2026 06:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.167.242.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785738686; cv=none; b=kXQtbNxBKmzgEPQQFzMZEC+xt3P1DnE6mr6sJCCHNsBPo73UchO6OF81SHdbjcPWjQCMymSe5h7xhiySgjlbiHfpPOxcIp2ih/OaxJVxqgNLB6p9oI9UnP1wYYygwYkIsuhQISgwHSO1R+HsWQPkT7PlN4UxFrOgyrJM98OOdvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785738686; c=relaxed/simple;
	bh=0w26mLCibxmzad5cJ4RsBqQcZLwhm5292+fwf5AEBhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=SpiroXl7M7H0nhWnWb+cnXpRfn/Ws6M6SMBxHVCdQCYX+DRu+wPojcBNnsqrR+i9cmrjn8M7IT4lAdZGIKfWcMpTps/sX3uMLuipDijqrVKr2NbhkPUXwNtii3wSuYJQOXvaIDf9HxRqPxhDWrtawm77fgo8q68PFqnBC0fLZek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com; spf=pass smtp.mailfrom=ideasonboard.com; dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b=oer8sGJV; arc=none smtp.client-ip=213.167.242.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="oer8sGJV"
Received: from [192.168.88.20] (91-158-153-178.elisa-laajakaista.fi [91.158.153.178])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9B0DE512;
	Mon,  3 Aug 2026 08:30:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1785738612;
	bh=0w26mLCibxmzad5cJ4RsBqQcZLwhm5292+fwf5AEBhg=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
	b=oer8sGJVImG3eAdX/1tDX4OfNrWm4pjhxRA/1dweeK0/QNZxTPxYqBKHqEkpRPb3+
	 Egk1n6NaDUmYkxMzDpzoE4nw/3yETSw8cW+rrdPTRWBDGvsL/5y/zRRpTIM1V1Upa9
	 AsybJri2Bo0Ucca/CHkw+txSHZGcz913RI4heSi4=
Message-ID: <f428f54b-90dd-425a-b204-531df0e1d5fa@ideasonboard.com>
Date: Mon, 3 Aug 2026 09:31:14 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dt-bindings: Correct white-space style
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260801195613.235430-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Mike Leach <mike.leach@arm.com>,
 James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Jyri Sarha <jyri.sarha@iki.fi>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
 Patrice Chotard <patrice.chotard@foss.st.com>,
 Andi Shyti <andi.shyti@kernel.org>, Jassi Brar <jassisinghbrar@gmail.com>,
 Lee Jones <lee@kernel.org>, Johannes Berg <johannes@sipsolutions.net>,
 Jeff Johnson <jjohnson@kernel.org>, Viresh Kumar <vireshk@kernel.org>,
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
 Yangbo Lu <yangbo.lu@nxp.com>, =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?=
 <ukleinek@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Samuel Holland <samuel.holland@sifive.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Jens Wiklander <jenswi@kernel.org>,
 Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>,
 YC Hung <yc.hung@mediatek.com>, Svyatoslav Ryhel <clamor95@gmail.com>,
 Sean Wang <sean.wang@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Peter Ujfalusi <peter.ujfalusi@gmail.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 coresight@lists.linaro.org, linux-arm-msm@vger.kernel.org,
 linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-mediatek@lists.infradead.org, linux-gpio@vger.kernel.org,
 linux-i2c@vger.kernel.org, mfd@lists.linux.dev,
 linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
 linux-pm@vger.kernel.org, netdev@vger.kernel.org, linux-pwm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-usb@vger.kernel.org
From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
In-Reply-To: <20260801195613.235430-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 01/08/2026 22:56, Krzysztof Kozlowski wrote:
> Correct a few white-space issues, like double space after '=' or before
> bracket '{' characters, which will be flagged by dt-check-style.  No
> functional changes.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> 
> ---
> 
> Patch applies on Rob's for-next branch.
> ---
>   .../arm/firmware/linaro,optee-tz.yaml         |  8 +-
>   .../devicetree/bindings/arm/psci.yaml         | 18 ++--
>   .../bindings/arm/qcom,coresight-tnoc.yaml     |  2 +-
>   .../devicetree/bindings/ata/st,ahci.yaml      | 22 ++---
>   .../bindings/display/ti/ti,am65x-dss.yaml     | 12 +--
>   .../bindings/display/ti/ti,j721e-dss.yaml     | 96 +++++++++----------
>   .../bindings/display/ti/ti,k2g-dss.yaml       | 36 +++----
>   .../bindings/dsp/mediatek,mt8195-dsp.yaml     |  2 +-
>   .../bindings/gpio/st,nomadik-gpio.yaml        |  2 +-
>   .../devicetree/bindings/i2c/st,sti-i2c.yaml   |  2 +-
>   .../bindings/mailbox/st,sti-mailbox.yaml      |  2 +-
>   .../bindings/mfd/maxim,max77620.yaml          |  2 +-
>   .../bindings/net/wireless/qcom,ath10k.yaml    | 34 +++----
>   .../devicetree/bindings/opp/opp-v2.yaml       | 28 +++---
>   .../pinctrl/mediatek,mt7988-pinctrl.yaml      |  2 +-
>   .../devicetree/bindings/ptp/fsl,ptp.yaml      | 12 +--
>   .../devicetree/bindings/pwm/pwm-sifive.yaml   |  2 +-
>   .../bindings/usb/ti,twl4030-usb.yaml          |  2 +-
>   18 files changed, 142 insertions(+), 142 deletions(-)


> diff --git a/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml b/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml
> index 49a007cbcd3a..d1e530e12604 100644
> --- a/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml
> +++ b/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml
> @@ -261,9 +261,9 @@ examples:
>                   "ovr1", "ovr2", "vp1", "vp2", "common1";
>           ti,am65x-oldi-io-ctrl = <&dss_oldi_io_ctrl>;
>           power-domains = <&k3_pds 67 TI_SCI_PD_EXCLUSIVE>;
> -        clocks =        <&k3_clks 67 1>,
> -                        <&k3_clks 216 1>,
> -                        <&k3_clks 67 2>;
> +        clocks = <&k3_clks 67 1>,
> +                 <&k3_clks 216 1>,
> +                 <&k3_clks 67 2>;
>           clock-names = "fck", "vp1", "vp2";
>           interrupts = <GIC_SPI 166 IRQ_TYPE_EDGE_RISING>;
>           ports {
> @@ -299,9 +299,9 @@ examples:
>               reg-names = "common", "vidl1", "vid",
>                           "ovr1", "ovr2", "vp1", "vp2", "common1";
>               power-domains = <&k3_pds 186 TI_SCI_PD_EXCLUSIVE>;
> -            clocks =        <&k3_clks 186 6>,
> -                            <&vp1_clock>,
> -                            <&k3_clks 186 2>;
> +            clocks = <&k3_clks 186 6>,
> +                     <&vp1_clock>,
> +                     <&k3_clks 186 2>;
>               clock-names = "fck", "vp1", "vp2";
>               interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
>               oldi-transmitters {
> diff --git a/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml b/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml
> index 65ae8a1c3998..cac5ef1743d3 100644
> --- a/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml
> +++ b/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml
> @@ -154,54 +154,54 @@ examples:
>       #include <dt-bindings/soc/ti,sci_pm_domain.h>
>   
>       dss: dss@4a00000 {
> -            compatible = "ti,j721e-dss";
> -            reg =   <0x04a00000 0x10000>, /* common_m */
> -                    <0x04a10000 0x10000>, /* common_s0*/
> -                    <0x04b00000 0x10000>, /* common_s1*/
> -                    <0x04b10000 0x10000>, /* common_s2*/
> -                    <0x04a20000 0x10000>, /* vidl1 */
> -                    <0x04a30000 0x10000>, /* vidl2 */
> -                    <0x04a50000 0x10000>, /* vid1 */
> -                    <0x04a60000 0x10000>, /* vid2 */
> -                    <0x04a70000 0x10000>, /* ovr1 */
> -                    <0x04a90000 0x10000>, /* ovr2 */
> -                    <0x04ab0000 0x10000>, /* ovr3 */
> -                    <0x04ad0000 0x10000>, /* ovr4 */
> -                    <0x04a80000 0x10000>, /* vp1 */
> -                    <0x04aa0000 0x10000>, /* vp2 */
> -                    <0x04ac0000 0x10000>, /* vp3 */
> -                    <0x04ae0000 0x10000>, /* vp4 */
> -                    <0x04af0000 0x10000>; /* wb */
> -            reg-names = "common_m", "common_s0",
> -                    "common_s1", "common_s2",
> -                    "vidl1", "vidl2","vid1","vid2",
> -                    "ovr1", "ovr2", "ovr3", "ovr4",
> -                    "vp1", "vp2", "vp3", "vp4",
> -                    "wb";
> -            clocks =        <&k3_clks 152 0>,
> -                            <&k3_clks 152 1>,
> -                            <&k3_clks 152 4>,
> -                            <&k3_clks 152 9>,
> -                            <&k3_clks 152 13>;
> -            clock-names = "fck", "vp1", "vp2", "vp3", "vp4";
> -            power-domains = <&k3_pds 152 TI_SCI_PD_EXCLUSIVE>;
> -            interrupts =    <GIC_SPI 602 IRQ_TYPE_LEVEL_HIGH>,
> -                            <GIC_SPI 603 IRQ_TYPE_LEVEL_HIGH>,
> -                            <GIC_SPI 604 IRQ_TYPE_LEVEL_HIGH>,
> -                            <GIC_SPI 605 IRQ_TYPE_LEVEL_HIGH>;
> -            interrupt-names =       "common_m",
> -                                    "common_s0",
> -                                    "common_s1",
> -                                    "common_s2";
> -            ports {
> -                    #address-cells = <1>;
> -                    #size-cells = <0>;
> -                    port@0 {
> -                            reg = <0>;
> +        compatible = "ti,j721e-dss";
> +        reg = <0x04a00000 0x10000>, /* common_m */
> +              <0x04a10000 0x10000>, /* common_s0*/
> +              <0x04b00000 0x10000>, /* common_s1*/
> +              <0x04b10000 0x10000>, /* common_s2*/
> +              <0x04a20000 0x10000>, /* vidl1 */
> +              <0x04a30000 0x10000>, /* vidl2 */
> +              <0x04a50000 0x10000>, /* vid1 */
> +              <0x04a60000 0x10000>, /* vid2 */
> +              <0x04a70000 0x10000>, /* ovr1 */
> +              <0x04a90000 0x10000>, /* ovr2 */
> +              <0x04ab0000 0x10000>, /* ovr3 */
> +              <0x04ad0000 0x10000>, /* ovr4 */
> +              <0x04a80000 0x10000>, /* vp1 */
> +              <0x04aa0000 0x10000>, /* vp2 */
> +              <0x04ac0000 0x10000>, /* vp3 */
> +              <0x04ae0000 0x10000>, /* vp4 */
> +              <0x04af0000 0x10000>; /* wb */
> +        reg-names = "common_m", "common_s0",
> +                "common_s1", "common_s2",
> +                "vidl1", "vidl2","vid1","vid2",
> +                "ovr1", "ovr2", "ovr3", "ovr4",
> +                "vp1", "vp2", "vp3", "vp4",
> +                "wb";
> +        clocks = <&k3_clks 152 0>,
> +                 <&k3_clks 152 1>,
> +                 <&k3_clks 152 4>,
> +                 <&k3_clks 152 9>,
> +                 <&k3_clks 152 13>;
> +        clock-names = "fck", "vp1", "vp2", "vp3", "vp4";
> +        power-domains = <&k3_pds 152 TI_SCI_PD_EXCLUSIVE>;
> +        interrupts = <GIC_SPI 602 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 603 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 604 IRQ_TYPE_LEVEL_HIGH>,
> +                     <GIC_SPI 605 IRQ_TYPE_LEVEL_HIGH>;
> +        interrupt-names = "common_m",
> +                          "common_s0",
> +                          "common_s1",
> +                          "common_s2";
> +        ports {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            port@0 {
> +                reg = <0>;
>   
> -                            dpi_out_0: endpoint {
> -                                    remote-endpoint = <&dp_bridge_input>;
> -                            };
> -                    };
> +                dpi_out_0: endpoint {
> +                    remote-endpoint = <&dp_bridge_input>;
> +                };
>               };
> +        };
>       };
> diff --git a/Documentation/devicetree/bindings/display/ti/ti,k2g-dss.yaml b/Documentation/devicetree/bindings/display/ti/ti,k2g-dss.yaml
> index 96b1439f88e3..87721da0a8af 100644
> --- a/Documentation/devicetree/bindings/display/ti/ti,k2g-dss.yaml
> +++ b/Documentation/devicetree/bindings/display/ti/ti,k2g-dss.yaml
> @@ -80,26 +80,26 @@ examples:
>       #include <dt-bindings/interrupt-controller/arm-gic.h>
>       #include <dt-bindings/interrupt-controller/irq.h>
>   
> -    dss: dss@2540000 {
> -            compatible = "ti,k2g-dss";
> -            reg =   <0x02540000 0x400>,
> -                    <0x02550000 0x1000>,
> -                    <0x02557000 0x1000>,
> -                    <0x0255a800 0x100>,
> -                    <0x0255ac00 0x100>;
> -            reg-names = "cfg", "common", "vid1", "ovr1", "vp1";
> -            clocks =        <&k2g_clks 0x2 0>,
> -                            <&k2g_clks 0x2 1>;
> -            clock-names = "fck", "vp1";
> -            interrupts = <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>;
> +    dss@2540000 {
> +        compatible = "ti,k2g-dss";
> +        reg = <0x02540000 0x400>,
> +              <0x02550000 0x1000>,
> +              <0x02557000 0x1000>,
> +              <0x0255a800 0x100>,
> +              <0x0255ac00 0x100>;
> +        reg-names = "cfg", "common", "vid1", "ovr1", "vp1";
> +        clocks = <&k2g_clks 0x2 0>,
> +                 <&k2g_clks 0x2 1>;
> +        clock-names = "fck", "vp1";
> +        interrupts = <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>;
>   
> -            power-domains = <&k2g_pds 0x2>;
> +        power-domains = <&k2g_pds 0x2>;
>   
> -            max-memory-bandwidth = <230000000>;
> +        max-memory-bandwidth = <230000000>;
>   
> -            port {
> -                    dpi_out: endpoint {
> -                            remote-endpoint = <&sii9022_in>;
> -                    };
> +        port {
> +            dpi_out: endpoint {
> +                remote-endpoint = <&sii9022_in>;
>               };
> +        };
>       };
For the TI DSS parts:

Acked-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

  Tomi


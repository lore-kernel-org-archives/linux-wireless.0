Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60337 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbcGMHCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 03:02:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	mcgrof@do-not-panic.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, robh+dt@kernel.org, chunkeey@googlemail.com,
	arend.vanspriel@broadcom.com, julian.calaby@gmail.com
Subject: Re: [PATCH v4 1/3] Documentation: dt: net: add ath9k wireless device binding
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
	<20160709232834.31654-1-martin.blumenstingl@googlemail.com>
	<20160709232834.31654-2-martin.blumenstingl@googlemail.com>
Date: Wed, 13 Jul 2016 10:02:39 +0300
In-Reply-To: <20160709232834.31654-2-martin.blumenstingl@googlemail.com>
	(Martin Blumenstingl's message of "Sun, 10 Jul 2016 01:28:32 +0200")
Message-ID: <87a8hmauls.fsf@purkki.adurom.net> (sfid-20160713_090316_941553_EC875C05)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> Add documentation how devicetree can be used to configure ath9k based
> devices.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  .../devicetree/bindings/net/wireless/qca,ath9k.txt | 59 ++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> new file mode 100644
> index 0000000..7c62c59
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> @@ -0,0 +1,59 @@
> +* Qualcomm Atheros ath9k wireless devices
> +
> +This node provides properties for configuring the ath9k wireless device. The
> +node is expected to be specified as a child node of the PCI controller to
> +which the wireless chip is connected.
> +
> +Required properties:
> +- compatible: Should be "qca,ath9k"

Isn't this supposed to use the chipset name? ath9k is the driver name
and something like ar9462 is the chip name. I know in ath10k we used
"qca,ath10k" but I'm starting to suspect that was a mistake.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:60181 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaK0M27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 07:28:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, toshik@chromium.org
Subject: Re: [PATCH v4 1/2] dt: bindings: add ath10k wireless device
Date: Thu, 27 Nov 2014 13:28:45 +0100
Message-ID: <3202372.2AaH3c4qv1@wuerfel> (sfid-20141127_132904_466667_0A65A3B5)
In-Reply-To: <20141127120856.17546.32014.stgit@potku.adurom.net>
References: <20141127120727.17546.61202.stgit@potku.adurom.net> <20141127120856.17546.32014.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 November 2014 14:08:56 Kalle Valo wrote:
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> new file mode 100644
> index 000000000000..edefc26c6204
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -0,0 +1,30 @@
> +* Qualcomm Atheros ath10k wireless devices
> +
> +For ath10k devices the calibration data can be provided through Device
> +Tree. The node is a child node of the PCI controller.
> +
> +Required properties:
> +-compatible : Should be "qcom,ath10k"
> +
> +Optional properties:
> +- qcom,ath10k-calibration-data : calibration data as an array, the
> +                                length can vary between hw versions
> +

Does the device always have a valid mac address in hardware? If not,
how about listing that as well using the mac-address property?

	Arnd

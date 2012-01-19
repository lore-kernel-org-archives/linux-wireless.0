Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41780 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2ASGYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 01:24:24 -0500
Message-ID: <4F17B712.6020907@qca.qualcomm.com> (sfid-20120119_072428_555325_40B555BB)
Date: Thu, 19 Jan 2012 08:24:18 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jonathan Bagg <jbagg@lenbrook.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath6kl in compat wireless supports AP mode?
References: <4F10AA2D.1060000@lenbrook.com>	<4F16AF8D.6070201@qca.qualcomm.com> <20246.46742.295455.729628@gargle.gargle.HOWL> <4F172101.3010207@lenbrook.com>
In-Reply-To: <4F172101.3010207@lenbrook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2012 09:44 PM, Jonathan Bagg wrote:

> I'm running....
> Compat-wireless 3.1 (ath6kl still in staging) built against kernel 2.6.35.3
>      mac80211 as module
>      cfg80211 as module
> hostapd v2.0-devel (git cloned today)
> libnl-2.0
> arm, freescale imx51
> 
> I tried hostapd v2.0-devel and no go.

If ath6kl is still in staging you have an ancient version and it will
not support AP mode. Please try latest wireless-compat or use the latest
kernel from ath6kl.git:

git://github.com/kvalo/ath6kl.git

Kalle

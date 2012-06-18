Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1714 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2FRGAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 02:00:38 -0400
From: Wei Ni <wni@nvidia.com>
To: 'Franky Lin' <frankyl@broadcom.com>
CC: 'Stephen Warren' <swarren@wwwdotorg.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Mursalin Akon <makon@nvidia.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	Rakesh Kumar <krakesh@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 18 Jun 2012 14:00:33 +0800
Subject: RE: Where to power on the wifi device before loading the driver.
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C6EE2DD61E@HKMAIL01.nvidia.com> (sfid-20120618_080043_702916_86917CBB)
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
 <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
 <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
 <4FDB61C9.9020505@broadcom.com>
In-Reply-To: <4FDB61C9.9020505@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 16, 2012 at 00:24:41, Franky Lin wrote:
>On 06/14/2012 11:09 PM, Wei Ni wrote:
>> I talked with Franky, this power sequence is generally for 4329, so it mean this sequence can be put into the wifi driver.
>
>Hold on. It's generally for 4329. But fullmac supports 4329/4330 along 
>with USB dongle chips. Also more chips are incoming. I dont think it's a good idea to add *this* power sequence into brcmfmac.

Ok we need find other ways for it. Thanks for your comments.

Wei
---
nvpublic



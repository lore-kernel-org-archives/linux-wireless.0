Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3516 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab2FOQkL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 12:40:11 -0400
Message-ID: <4FDB61C9.9020505@broadcom.com> (sfid-20120615_184016_304218_257206A1)
Date: Fri, 15 Jun 2012 09:24:41 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Wei Ni" <wni@nvidia.com>
cc: "'Stephen Warren'" <swarren@wwwdotorg.org>,
	"Mark Brown" <broonie@opensource.wolfsonmicro.com>,
	"Thierry Reding" <thierry.reding@avionic-design.de>,
	"Mursalin Akon" <makon@nvidia.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"Rakesh Kumar" <krakesh@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Where to power on the wifi device before loading the
 driver.
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
 <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
 <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
Content-Type: text/plain;
 charset=windows-1252;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/14/2012 11:09 PM, Wei Ni wrote:
> I talked with Franky, this power sequence is generally for 4329, so it mean this sequence can be put into the wifi driver.

Hold on. It's generally for 4329. But fullmac supports 4329/4330 along 
with USB dongle chips. Also more chips are incoming. I dont think it's a 
good idea to add *this* power sequence into brcmfmac.

Franky


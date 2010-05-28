Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:48478 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0E1SU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:20:29 -0400
Message-ID: <20100528212027.208560d9qwrmgjnk@hayate.sektori.org>
Date: Fri, 28 May 2010 21:20:27 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"David Quan" <David.Quan@atheros.com>
Subject: Re: [PATCH] ath5k: disable ASPM
References: <20100528100901.14580.1322.stgit@fate.lan>
	<AANLkTim27Widx4NuaN_C6XqeLkCahRA8zTEDuDtxi_vM@mail.gmail.com>
In-Reply-To: <AANLkTim27Widx4NuaN_C6XqeLkCahRA8zTEDuDtxi_vM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

> On Fri, May 28, 2010 at 3:09 AM, Jussi Kivilinna
> <jussi.kivilinna@mbnet.fi> wrote:
>> Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
>> Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
>> enabled. With ASPM ath5k will eventually stall on heavy traffic with often
>> 'unsupported jumbo' warnings appearing. Disabling ASPM L0s/L1 in ath5k fixes
>> these problems.
>
> So you disable ASPM all together on the entire driver?
>

Sorry, I meant to this to be RFC patch. I'm not familiar with PCI  
devices/drivers.. How should I pinpoint this patch? To 168c:001c? only  
rev 1? Is there other revs that don't mix with ASPM? Is this AOA150  
problem only? Use AOA150 specific quirk?

-Jussi


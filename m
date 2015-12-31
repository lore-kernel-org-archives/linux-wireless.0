Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41829 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbbLaPZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 10:25:16 -0500
Message-ID: <568548DA.10205@candelatech.com> (sfid-20151231_162544_226613_62D3D8C4)
Date: Thu, 31 Dec 2015 07:25:14 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: voncken <cedric.voncken@acksys.fr>,
	'Emmanuel Grumbach' <egrumbach@gmail.com>
CC: 'linux-wireless' <linux-wireless@vger.kernel.org>
Subject: Re: Mac80211 : Wpa rekeying issue
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>	<CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>	<0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>	<0a6a01d143a2$fcb77720$f6266560$@acksys.fr> <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com> <0a7101d143b4$3480de10$9d829a30$@acksys.fr>
In-Reply-To: <0a7101d143b4$3480de10$9d829a30$@acksys.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/31/2015 02:15 AM, voncken wrote:

> Thanks for your answer.
> Do you know if we can have the same issue with ATH10K chipset?

Someone else reported re-keying problems with ath10k recently, and
it appears to be a bug in in upstream firmware, probably related to
the same issue that keeps 802.11r from working in some upstream
firmware...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

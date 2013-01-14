Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55282 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab3ANHBM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 02:01:12 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Q: how to update platform power state for the network driver
References: <6929081.7c7blFVDp4@lx-vladimir>
	<87ehhsu38q.fsf@purkki.adurom.net> <1550342.hytzsOV4KI@lx-vladimir>
Date: Mon, 14 Jan 2013 09:01:10 +0200
In-Reply-To: <1550342.hytzsOV4KI@lx-vladimir> (Vladimir Kondratiev's message
	of "Sun, 13 Jan 2013 09:33:54 +0200")
Message-ID: <8738y41c5l.fsf@purkki.adurom.net> (sfid-20130114_080116_396614_7B618883)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> On Thursday, January 10, 2013 11:39:33 PM Kalle Valo wrote:
>> Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:
>> 
>> > in 60g spec (802.11ad, references to this doc.), station should set "power source" bit in the:
> [skip]
>> 
>> Scary! Just of curiosity, how is this bit supposed to be used in real life?
>> 
>
> In 60g, you have new ah-hoc network type, PBSS, that should be used for P2P (spec mandates it)
> In PBSS, there is AP-like entity called PCP. Instead of P2P GO negotiation, GO choosen before,
> on lower layer, when selecting PCP. In this decision, "best suitable" candidate selected PCP,
> based on "PCP factor" calculated for each peer. Most significant bit there is "power" since
> one who is AC powered is better candidate.
>
> Bottom line - this is to elect as P2P GO AC-powered one (if there is such peer).

Ok, so it's just a sort of priority bit. That's not bad.

-- 
Kalle Valo

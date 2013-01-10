Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33658 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab3AJVjg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 16:39:36 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Q: how to update platform power state for the network driver
References: <6929081.7c7blFVDp4@lx-vladimir>
Date: Thu, 10 Jan 2013 23:39:33 +0200
In-Reply-To: <6929081.7c7blFVDp4@lx-vladimir> (Vladimir Kondratiev's message
	of "Wed, 9 Jan 2013 19:20:06 +0200")
Message-ID: <87ehhsu38q.fsf@purkki.adurom.net> (sfid-20130110_223940_002275_9E32D364)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> in 60g spec (802.11ad, references to this doc.), station should set "power source" bit in the:
>
> 8.4.2.130.3 DMG PCP/AP Capability Information field
>
> This information used to construct "PCP factor" that used in:
>
> 10.1.4.3.4 PCP selection in a PBSS
>
> This procedure replaces GO negotiation in P2P. "power source" bit above specified as:
>
> The Power Source field is set to 0 if the STA is battery powered, and is set to 1 otherwise.

Scary! Just of curiosity, how is this bit supposed to be used in real life?

-- 
Kalle Valo

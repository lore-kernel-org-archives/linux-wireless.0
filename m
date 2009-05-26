Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18521 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZEZFXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 01:23:55 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 May 2009 22:23:57 -0700
Date: Tue, 26 May 2009 10:52:46 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Galen P Zink <galen@zinkconsulting.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Ath9k Quality / STBC
Message-ID: <20090526052246.GG4584@vasanth-laptop>
References: <CD5942A5-7449-42DC-92B3-1FB8F967005B@zinkconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CD5942A5-7449-42DC-92B3-1FB8F967005B@zinkconsulting.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2009 at 04:48:25AM +0530, Galen P Zink wrote:
> What's the current status of ath9k in terms of quality?

good.

> access point? 

Works fine, hostpad needs to be used for AP mode.

>Are all the Atheros 9xxx series chipsets supported?

All 9xxx family chipsets available in market are supported.

> 
> The only feature I see that's missing is STBC. It seems like STBC is a
> pretty useful feature with 802.11n MIMO and the three(!) rx capability
> of many of the Atheros cards. Is there a reason STBC is not
> implemented?

Yeah, it does not have STBC support. There is no reason for not
having this feature, we have a plan for this one.

> Has anybody done any comparisons?

No.

Vasanth


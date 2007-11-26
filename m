Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:55137 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXKZVKX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 16:10:23 -0500
Date: Mon, 26 Nov 2007 22:10:22 +0100
From: Ulrich Kunitz <kune@deine-taler.de>
To: Kiran Shastri <kshastri@mainex1.asu.edu>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ZyDAS adhoc mode in 802.11a for usb adapters(Zyxel AG-220 etc)
Message-ID: <20071126211022.GA14184@deine-taler.de> (sfid-20071126_211028_412051_1B65911E)
References: <70259E5A1BDC824CAA6F4909DB4A5F7F041CFC93@EX03.asurite.ad.asu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <70259E5A1BDC824CAA6F4909DB4A5F7F041CFC93@EX03.asurite.ad.asu.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kiran Shastri wrote:

> I am trying to set up an wireless ad hoc network operating on 802.11a channels. I am looking for an USB wireless adapter that can operate in IBSS (ad hoc) mode in 802.11a. I came across three wireless adapters from Zyxel, namely, AG-220, AG-225H, AG-225Hv2. I was wondering if any of these adapters or adapters from any other manufacturer supports IBSS operation with 802.11a in Linux.
> 
> Thank you,
>  
> Kiran.
>  
> Kiran Shastri,
> Graduate Student,
> CSE Dept.,
> ASU

Kisan,

I believe those devices are using the ZD1211 and ZD1211B chip.
However the current available Linux drivers don't support Adhoc
as 802.11a. However there is no general issue, which should
prevent the support of this functionality.

-- 
Uli Kunitz

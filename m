Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from epo-int2.asu.edu ([129.219.187.21]:43663 "EHLO epo-int2.asu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781AbXK0Rqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 12:46:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: RE: ZyDAS adhoc mode in 802.11a for usb adapters(Zyxel AG-220 etc)
Date: Tue, 27 Nov 2007 10:44:16 -0700
Message-ID: <70259E5A1BDC824CAA6F4909DB4A5F7F041CFC96@EX03.asurite.ad.asu.edu> (sfid-20071127_174639_671329_FB73000E)
References: <70259E5A1BDC824CAA6F4909DB4A5F7F041CFC93@EX03.asurite.ad.asu.edu> <20071126211022.GA14184@deine-taler.de>
From: "Kiran Shastri" <kshastri@mainex1.asu.edu>
To: "Ulrich Kunitz" <kune@deine-taler.de>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ulrich,
Thanks for the response
Do you mean that it can work? 
Is there any reason behind why linux drivers don't support 802.11a adhoc mode?
Thanks,
Kiran
Kiran Shastri,
Graduate Student,
CSE Dept.,
ASU

________________________________

From: Ulrich Kunitz [mailto:kune@deine-taler.de]
Sent: Mon 11/26/2007 2:10 PM
To: Kiran Shastri
Cc: linux-wireless@vger.kernel.org
Subject: Re: ZyDAS adhoc mode in 802.11a for usb adapters(Zyxel AG-220 etc)



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



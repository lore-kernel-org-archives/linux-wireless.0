Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:52447 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbXJVRZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 13:25:43 -0400
From: Frans Pop <elendil@planet.nl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k] Help needed for Trust Speedshare Turbo Pro (PCMCIA)
Date: Mon, 22 Oct 2007 19:25:37 +0200
Cc: linux-wireless@vger.kernel.org
References: <200710211316.06772.elendil@planet.nl> <200710221848.27985.elendil@planet.nl> <43e72e890710221011p2b2f66d8w3f341bec068e49f1@mail.gmail.com>
In-Reply-To: <43e72e890710221011p2b2f66d8w3f341bec068e49f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710221925.37758.elendil@planet.nl> (sfid-20071022_182545_498981_207E0CF7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 October 2007, Luis R. Rodriguez wrote:
> >  -==Device Information==-
> > MAC Version:  5212 (0x50)
> > MAC Revision: 5213A(0x59)
> > PHY Revision: 5110 (0x0)
> > PHY Revision: 5110 (0x0)
>
> This is the problem. ath5k currently assumes only AR5210s (which are
> 802.11a only capable) have an RF5110. This is also an 802.11bg card.
> Essentially support for this is on the TODO list. For now we'll have
> to just detect this and inform users the card is not supported yet.

OK. Thanks for the info.
I'd gotten the impression that the driver was a bit further along. No 
problem though. I'll just stay alert for announcements.

Cheers,
FJP

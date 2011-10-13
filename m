Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49157 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1JMDpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 23:45:53 -0400
Date: Thu, 13 Oct 2011 09:16:26 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] ath9k_hw: Fix ASPM L1 issue for AR9462
Message-ID: <20111013034625.GA5302@vmraj-lnx.users.atheros.com> (sfid-20111013_054602_763846_693A5B08)
References: <1318226145-7772-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20111012184043.GG18764@tuxdriver.com>
 <20111012185034.GH18764@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20111012185034.GH18764@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 12, 2011 at 02:50:34PM -0400, John W. Linville wrote:
> On Wed, Oct 12, 2011 at 02:40:44PM -0400, John W. Linville wrote:
> > On Mon, Oct 10, 2011 at 11:25:45AM +0530, Rajkumar Manoharan wrote:
> > > Because of not clearing Bit 14 of AR_WA, the ASPM L1 is not
> > > enabled when entering into sleep mode. AR9462 does not need
> > > bit 14 to be set.
> > > 
> > > Cc: stable@kernel.org
> > > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > 
> >   CC [M]  drivers/net/wireless/ath/ath9k/hw.o
> > drivers/net/wireless/ath/ath9k/hw.c: In function ???__ath9k_hw_init???:
> > drivers/net/wireless/ath/ath9k/hw.c:544:2: error: implicit declaration of function ???AR_SREV_9462???
> > 
> > Missing a patch dependency?
> 
> I see that is defined by a series posted just before that -- one that
> hasn't even appeared in wireless-next yet.  Cc: stable@kernel.org
> seems a bit inappropriate...
> 
> That series needs rework anyway -- how about you just fold this one
> into that earlier series?
>
First of all sorry for the inconvenience. While splitting stable patch
from the patchset, I made it on top of patchset that caused the dependancy.
I will resend patch.

--
Rajkumar

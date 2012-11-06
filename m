Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30826 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2KFQra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 11:47:30 -0500
Date: Tue, 6 Nov 2012 22:17:33 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith <m.sujith@gmail.com>, Felix Fietkau <nbd@openwrt.org>
CC: Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	<rodrigue@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<backports@vger.kernel.org>
Subject: Re: [PATCH 2/2] compat-drivers: Add a next-pending patch.
Message-ID: <20121106164732.GA10101@hemis.qca.qualcomm.com> (sfid-20121106_174743_275001_46A322F8)
References: <1352197894-4352-1-git-send-email-bkamatch@qca.qualcomm.com>
 <1352197894-4352-3-git-send-email-bkamatch@qca.qualcomm.com>
 <20633.14711.832133.513286@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20633.14711.832133.513286@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 06, 2012 at 09:53:19PM +0530, Sujith wrote:
> Bala Shanmugam wrote:
> > Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> > ---
> >  ...x-signal-strength-noise-measurements-on-a.patch |   28 ++++++++++++++++++++
> >  1 files changed, 28 insertions(+), 0 deletions(-)
> >  create mode 100644 linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch
> > 
> > diff --git a/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch b/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch
> > new file mode 100644
> > index 0000000..727c904
> > --- /dev/null
> > +++ b/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch
> > @@ -0,0 +1,28 @@
> > +From f91a5adf7e8d778f8f006934400249ec9c84717c Mon Sep 17 00:00:00 2001
> > +From: Felix Fietkau <nbd@openwrt.org>
> > +Date: Fri, 2 Nov 2012 16:23:47 +0530
> > +Subject: [PATCH] ath9k_hw: fix signal strength / noise measurements on ar9462
> > +
> > +The nominal noise floor for most channels is -120, though on some it can
> > +reach -127. Use -120 for converting noise floor to channel noise to
> > +avoid overestimating rx signal strength and channel noise.
> 
> I don't think this patch has been posted to linux-wireless.
> linux-next-pending/ can only accept patches that have been posted and reviewed.
> 
> Also, this change has to be verified with the internal systems team.
> 
Agree. But this change is taken from Chrome kernel tree and it was already
reviewed by Systems.

Felix,

Any comments. Can you please post this change?

-Rajkumar

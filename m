Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5409 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbbI3CFb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 22:05:31 -0400
From: David Lin <dlin@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	Chor Teck Law <ctlaw@marvell.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: RE: [PATCH v5] Add new mac80211 driver mwlwifi.
Date: Wed, 30 Sep 2015 02:05:24 +0000
Message-ID: <63b962e0771b4279aa0f1a4cf1f01516@SC-EXCH02.marvell.com> (sfid-20150930_040535_598174_59AE33EF)
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
	<1436455659.36587.131.camel@sakura.staff.proxad.net>
	<87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
	<20150804220956.GA28583@sakura.staff.proxad.net>
	<1d5d24295c1c45ec856c908c60dab13b@SC-EXCH03.marvell.com>
	<87vbbmeasb.fsf@kamboji.qca.qualcomm.com>
	<5743c7447a834df1bf719dfa3444e9cd@SC-EXCH03.marvell.com>
	<87eghh7g30.fsf@kamboji.qca.qualcomm.com>
 <87y4fp5yd2.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87y4fp5yd2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
> > Chor Teck Law <ctlaw@marvell.com> writes:
> >
> >> But for different generation of future chipsets/new technology, when
> >> the hardware no longer permit us to use same driver, we will have to
> >> re-evaluate our options. We cannot guarantee something way out into
> >> the future.
> >
> > Yeah, that's understandable. But the community really dislikes having
> > duplicated code/functionality, so please keep this in mind.
> >
> > If you can submit the next version soon we could try to get this
> > driver to 4.4. We have few more weeks.
> 
> I forgot to ask about the firmware image for this driver. Is that available in
> linux-firmware.git?
>

I had already sent firmware patch for linux-firmware.git. However, it looks like it had not yet been added to linux-firmware.git. After sending out Patch v7, I will check to see if this patch can be added to linux-firmware.git.

> --
> Kalle Valo

Thanks,
David

From: David Lin <dlin@...>
Subject: [PATCH] Add FW binary used by mwlwifi driver.
Newsgroups: gmane.linux.kernel.wireless.general
Date: 2015-08-22 03:54:38 GMT (5 weeks, 3 days, 22 hours and 7 minutes ago)
Signed-off-by: David Lin <dlin-eYqpPyKDWXRBDgjK7y7TUQ <at> public.gmane.org>
---
 WHENCE              |  12 ++++++++++++
 mwlwifi/88W8864.bin | Bin 0 -> 116356 bytes
 mwlwifi/88W8897.bin | Bin 0 -> 489084 bytes
 3 files changed, 12 insertions(+)
 mode change 100644 => 100755 WHENCE
 create mode 100755 mwlwifi/88W8864.bin
 create mode 100755 mwlwifi/88W8897.bin

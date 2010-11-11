Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23139 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0KKPVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 10:21:41 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 07:21:28 -0800
From: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 11 Nov 2010 20:51:37 +0530
Subject: RE: [PATCH] ath9k_htc: Add new devices into AR7010
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6CE@CHEXMB-01.global.atheros.com>
References: <1289389041-26938-1-git-send-email-rmanoharan@atheros.com>
 <20101110131356.GA27734@vmraj-lnx.users.atheros.com>
 <20101111132341.GA8029@vmraj-lnx.users.atheros.com>,<201011111512.30343.chunkeey@googlemail.com>
In-Reply-To: <201011111512.30343.chunkeey@googlemail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>On Thursday 11 November 2010 14:23:41 Rajkumar Manoharan wrote:
>> On Wed, Nov 10, 2010 at 06:43:57PM +0530, Rajkumar Manoharan wrote:
> >> On Wed, Nov 10, 2010 at 06:05:14PM +0530, Christian Lamparter wrote:
> > >> On Wednesday 10 November 2010 12:37:21 Rajkumar Manoharan wrote:
> > > >> Treat PIDs (0xA704, 0x1200) as AR7010 devices.
> > >>
> > > >just a though, but instead of relying only on the pid and
>> > > hope for no collisions. you could put a @driver_info flag
>> > > for all AR7010 devices into the usb_device_id table and
> >> > remove the per-device "cases".
> > >>
>> > Make sense. Thanks for your review. I'll resend the patch.
>> >
>> After adding @driver_info to replace per-device cases,
>> the patch looks like cleanup one which is not compatible for stable kernel.
>> So let the previous patches to be integrated, due to minimal changes.
>> And I'll submit the cleanup patch separately. Is that fine?
>sure?
>
> Or is this a question directed to John?

Both you and John. Since these patches are stable and enable support to new devices,
I prefer to go with minimal changes. I will submit the cleanup patches to wireless-testing.

Any comments John?

--
Rajkumar
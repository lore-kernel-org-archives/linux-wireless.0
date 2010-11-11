Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19048 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722Ab0KKNQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 08:16:09 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 05:15:57 -0800
Date: Thu, 11 Nov 2010 18:53:41 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: Add new devices into AR7010
Message-ID: <20101111132341.GA8029@vmraj-lnx.users.atheros.com>
References: <1289389041-26938-1-git-send-email-rmanoharan@atheros.com>
 <201011101335.14311.chunkeey@googlemail.com>
 <20101110131356.GA27734@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101110131356.GA27734@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 06:43:57PM +0530, Rajkumar Manoharan wrote:
> On Wed, Nov 10, 2010 at 06:05:14PM +0530, Christian Lamparter wrote:
> > On Wednesday 10 November 2010 12:37:21 Rajkumar Manoharan wrote:
> > > Treat PIDs (0xA704, 0x1200) as AR7010 devices.
> > 
> > just a though, but instead of relying only on the pid and
> > hope for no collisions. you could put a @driver_info flag
> > for all AR7010 devices into the usb_device_id table and
> > remove the per-device "cases". 
> > 
> Make sense. Thanks for your review. I'll resend the patch.
>
After adding @driver_info to replace per-device cases,
the patch looks like cleanup one which is not compatible for stable kernel.
So let the previous patches to be integrated, due to minimal changes.
And I'll submit the cleanup patch separately. Is that fine ?

--
Rajkumar

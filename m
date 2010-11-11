Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46652 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0KKOMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:12:50 -0500
Received: by fxm16 with SMTP id 16so1326212fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 06:12:49 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: Re: [PATCH] ath9k_htc: Add new devices into AR7010
Date: Thu, 11 Nov 2010 15:12:29 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1289389041-26938-1-git-send-email-rmanoharan@atheros.com> <20101110131356.GA27734@vmraj-lnx.users.atheros.com> <20101111132341.GA8029@vmraj-lnx.users.atheros.com>
In-Reply-To: <20101111132341.GA8029@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011111512.30343.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 11 November 2010 14:23:41 Rajkumar Manoharan wrote:
> On Wed, Nov 10, 2010 at 06:43:57PM +0530, Rajkumar Manoharan wrote:
> > On Wed, Nov 10, 2010 at 06:05:14PM +0530, Christian Lamparter wrote:
> > > On Wednesday 10 November 2010 12:37:21 Rajkumar Manoharan wrote:
> > > > Treat PIDs (0xA704, 0x1200) as AR7010 devices.
> > > 
> > > just a though, but instead of relying only on the pid and
> > > hope for no collisions. you could put a @driver_info flag
> > > for all AR7010 devices into the usb_device_id table and
> > > remove the per-device "cases". 
> > > 
> > Make sense. Thanks for your review. I'll resend the patch.
> >
> After adding @driver_info to replace per-device cases,
> the patch looks like cleanup one which is not compatible for stable kernel.
> So let the previous patches to be integrated, due to minimal changes.
> And I'll submit the cleanup patch separately. Is that fine?
sure?

Or is this a question directed to John?

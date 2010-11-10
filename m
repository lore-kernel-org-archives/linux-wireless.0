Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26575 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab0KJNGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:06:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 05:06:12 -0800
Date: Wed, 10 Nov 2010 18:43:57 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: Add new devices into AR7010
Message-ID: <20101110131356.GA27734@vmraj-lnx.users.atheros.com>
References: <1289389041-26938-1-git-send-email-rmanoharan@atheros.com>
 <201011101335.14311.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201011101335.14311.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 06:05:14PM +0530, Christian Lamparter wrote:
> On Wednesday 10 November 2010 12:37:21 Rajkumar Manoharan wrote:
> > Treat PIDs (0xA704, 0x1200) as AR7010 devices.
> 
> just a though, but instead of relying only on the pid and
> hope for no collisions. you could put a @driver_info flag
> for all AR7010 devices into the usb_device_id table and
> remove the per-device "cases". 
> 
Make sense. Thanks for your review. I'll resend the patch.

--
Rajkumar

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:52295 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755253Ab0C3GBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 02:01:08 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH] rt2500usb: fix powersaving random failures
Date: Tue, 30 Mar 2010 08:01:00 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>, users@rt2x00.serialmonkey.com,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <201003290956.54234.linux@rainbow-software.org> <201003292300.12013.IvDoorn@gmail.com> <4BB18816.4040603@gmail.com>
In-Reply-To: <4BB18816.4040603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003300801.01849.linux@rainbow-software.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 March 2010, Gertjan van Wingerde wrote:
> On 03/29/10 23:00, Ivo van Doorn wrote:
> > On Monday 29 March 2010, Gertjan van Wingerde wrote:
> >> On 03/29/10 09:56, Ondrej Zary wrote:
> >>> This patch seems to fix random powersaving failure where the device
> >>> state is stuck at 1 (STATE_SLEEP) and does not change to 3
> >>> (STATE_AWAKE), resulting in to associate and these error messages:
> >>> phy0 -> rt2500usb_set_device_state: Error - Device failed to enter
> >>> state 3 (-16). No probe response from AP xx:xx:xx:xx:xx:xx after 500ms,
> >>> disconnecting.
> >>>
> >>> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >>
> >> Thanks. This looks good, but I'll rehash it against the latest state of
> >> affairs of rt2x00, so that the disabling of powersaving is undone at the
> >> same time.
> >>
> >> John, I'll send you the rehashed patch tomorrow.
> >
> > Is this change interesting for the other drivers as well?
> > Anyway, this one gets my Ack:
> >
> > Acked-By: Ivo van Doorn <IvDoorn@gmail.com>
>
> Correct. That is the other reason to rehash. At least rt2400pci and
> rt2500pci can use the same change.

I also have a PCI card with RT2560F (MSI MS-6834) but haven't tested it yet.

-- 
Ondrej Zary

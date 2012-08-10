Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879Ab2HJW1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 18:27:50 -0400
Date: Sat, 11 Aug 2012 00:27:47 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt73usb: WARN(x) in check_sdata_in_driver()
Message-ID: <20120810222746.GA19779@redhat.com> (sfid-20120811_002754_393492_69F9C41C)
References: <CANq1E4RFGq2M7uSOMZLGuZYSa7E5g6RoWfyLDLtgAdsORD_qWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANq1E4RFGq2M7uSOMZLGuZYSa7E5g6RoWfyLDLtgAdsORD_qWg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Sun, Jul 15, 2012 at 07:34:58PM +0200, David Herrmann wrote:
> I use an ASUStek WL-167g USB wlan adapter (quite old) using rt73usb.ko
> (Ralink). After resuming from suspend I get:
> 
> [152743.736783] ------------[ cut here ]------------
> [152743.736798] WARNING: at net/mac80211/driver-ops.h:12
> ieee80211_send_deauth_disassoc+0x1a8/0x1b0()
> [152743.736801] Hardware name: N150P/N210P/N220P
> [152743.736804] wlan0:  Failed check-sdata-in-driver check, flags: 0x4

Does it still happen on 3.5.1 ? 

Stanislaw


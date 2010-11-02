Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:51569 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab0KBPtT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 11:49:19 -0400
Date: Tue, 2 Nov 2010 16:49:12 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>, Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101102154911.GA593@sig21.net>
References: <4CC0D0F6.4080507@web.de>
 <20101102144625.GA32002@sig21.net>
 <AANLkTikYDHBSVuMEnUsR7WpPPo8rK0+OBm_Rd-H0znHT@mail.gmail.com>
 <201011021605.37137.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201011021605.37137.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 02, 2010 at 04:05:36PM +0100, Helmut Schaa wrote:
> Am Dienstag 02 November 2010 schrieb Ivo Van Doorn:
> > 
> > The legacy drivers from Ralink configure the BSSID, same as rt2x00 driver do,
> > when we start the association procedure. This complies with the 802.11 standard
> > for filtering the data frames.
> 
> Yep, Ivo is correct.

Ah, I see.  I missed the call in rt2x00mac_bss_info_changed().
Sorry for the noise and thanks for your comments.


Johannes

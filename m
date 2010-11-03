Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:43027 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab0KCPIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 11:08:51 -0400
Date: Wed, 3 Nov 2010 16:08:46 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101103150846.GB5798@sig21.net>
References: <4CC0D0F6.4080507@web.de>
 <201010290017.13174.helmut.schaa@googlemail.com>
 <4CCB3F24.1030701@web.de>
 <201010301430.15868.helmut.schaa@googlemail.com>
 <20101102125007.GA30000@sig21.net>
 <20101103141413.GA5364@sig21.net>
 <AANLkTimR8aGZs3AMWGFzMwKvvaTTEQt9ovL7yS7DTi9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimR8aGZs3AMWGFzMwKvvaTTEQt9ovL7yS7DTi9A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 03, 2010 at 03:50:20PM +0100, Ivo Van Doorn wrote:
> 
> Absolutely true, I committed a patch for that 1 or 2 weeks ago,
> so that should be visible in compat-wireless by now.

grmbl, I was looking at wireless-testing updated on Monday, and it
seems I got an outdated tree due to the hera server fuckup :-(

Johannes

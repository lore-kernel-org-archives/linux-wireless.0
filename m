Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36978 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab0IQQmY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 12:42:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 09:42:18 -0700
Date: Fri, 17 Sep 2010 09:42:23 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Chuck Crisler <ccrisler@vgocom.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: interrupts
Message-ID: <20100917164223.GC2008@tux>
References: <D6CF33887D864426B02D21261537559B@ChuckPC>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <D6CF33887D864426B02D21261537559B@ChuckPC>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 07:10:42AM -0700, Chuck Crisler wrote:
> Luis, our gizmo uses an IR interface that is poorly implemented but needs timely interrupts. It works well unless an AR9170 is plugged in. The hardware guy has put a scope on the board and claims that the interrupts are not being passed to the device. Where in the kernel or AR driver would I start looking for this problem?
> 
> I got my problems with the 9170 fixed. Now roaming looks rock solid, though it is slow (~6 seconds, mainly for the scan). The problem was in the wpa_supplicant.
> 
> Thank you,
> Chuck Crisler
> VGo Communications

Chuck, you're better off using the mailign lists, I don't work on ar9170,
Christian does though.

  Luis

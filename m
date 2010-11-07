Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web29507.mail.ird.yahoo.com ([77.238.189.134]:34255 "HELO
	web29507.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753999Ab0KGB3d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 21:29:33 -0400
Message-ID: <873714.85933.qm@web29507.mail.ird.yahoo.com>
Date: Sun, 7 Nov 2010 01:29:30 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 9/9] rtl8187: restore anaparam registers after reset with 8187B
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	seno <senada@t-online.de>
In-Reply-To: <20101106230731.3524ae6b@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Sun, 7/11/10, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

<snipped>
> It's strange that with or without the patch you get too low
> transfer
> values. In this case we should have another bug with your
> device. I don't
> know now what could be happening, but first thing that I
> thought is that
> this could be related to antenna selection (and I'm curious
> about analog
> parameters on the eeprom of device too). Please try
> following debug patch
> and post results (also post what type of RTL8187 the driver
> detects/prints
> on kernel log too, may help). And if is something related
> to antena selection,
> try change the if condition on the patch and see if that
> helps.
<snipped>

That reminds me - I have an "antenna diversity" patch dated "April 9 2009" on my desktop which I think I got off linux-wireless from somebody with a dual-antenna device, derived from scavenging from the vendor driver, I think, that we are supposed to do something about but I certainly haven't done anything about it. Did either/any of you look at that and/or remember having done anything about that patch? 



      

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51764 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbZJYQAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2009 12:00:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Begin implementing calibration & software  RFKILL support
Date: Sun, 25 Oct 2009 17:00:05 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1256484396-31063-1-git-send-email-netrolller.3d@gmail.com> <200910251654.17050.mb@bu3sch.de> <69e28c910910250857l341cc114w46224b94cda36f3e@mail.gmail.com>
In-Reply-To: <69e28c910910250857l341cc114w46224b94cda36f3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910251700.06859.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 25 October 2009 16:57:44 Gábor Stefanik wrote:
> 2009/10/25 Michael Buesch <mb@bu3sch.de>:
> > On Sunday 25 October 2009 16:26:36 Gábor Stefanik wrote:
> >> Michael, could you please do the PHY reset part? I can't seem to
> >> understand its relationship to wireless_core_reset... also, it's
> >> heavily ssb-speak, which I am not good at.
> >
> > Where are the specifications?
> >
> > --
> > Greetings, Michael.
> >
> 
> They are @ http://bcm-v4.sipsolutions.net/802.11/PHY/Reset - it shows
> some similarity to wireless_core_reset, but it is not an exact match.

Well, I don't know. Just implement it in another function.
I don't have the time to dig into this.

-- 
Greetings, Michael.

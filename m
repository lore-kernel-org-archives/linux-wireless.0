Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39784 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbZHXJIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 05:08:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: feng tian <feng.of.tian@gmail.com>
Subject: Re: Abour linux driver supports BCM4325
Date: Mon, 24 Aug 2009 11:08:43 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com> <f42a38140908230830r45ef1d01l5a9c5a4d0197e81e@mail.gmail.com> <f42a38140908232303j320f858cw5c0e45cc98a1e440@mail.gmail.com>
In-Reply-To: <f42a38140908232303j320f858cw5c0e45cc98a1e440@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908241108.43943.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 24 August 2009 08:03:12 feng tian wrote:
> >>>  1) changing b43 so it knows how to talk not just to SSB/PCI/PCMCIA
> >>>     chips but also SDIO chips
> >>
> >> We already have working support for that and we're currently merging it mainline.
> >> If you want to help, please test the spinlock removal patchset I just posted.
> 
> >>>  2) changing b43 so it knows how to talk to your specific radio/PHY
> >>>     chip, and LP PHY
> 
> Where can I get theses codes which supports b43 talking to SDIO chips?
> Thanks very much.

They are not ready for public review, yet. We're working on merging them mainline.
But it does basically work and we (Albert Herranz) got the SDIO chip on the Nintendo Wii running.


-- 
Greetings, Michael.

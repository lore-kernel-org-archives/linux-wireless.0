Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp203.alice.it ([82.57.200.99]:54909 "EHLO smtp203.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab2FYUJb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 16:09:31 -0400
Message-ID: <1340654635.3413.19.camel@gnutoo-hplaptop> (sfid-20120625_220934_503413_58EF87F6)
Subject: Re: Question about BCM43228 and outdated description in MAINTAINERS
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Date: Mon, 25 Jun 2012 22:03:55 +0200
In-Reply-To: <4FE88E1A.9050202@hauke-m.de>
References: <4FE886B3.7020202@lwfinger.net> <4FE88E1A.9050202@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 18:13 +0200, Hauke Mehrtens wrote:
> Add support for more chips, including (near term) BCM43227, BCM43228,
> and BCM4331. Support for additional new chips to follow. 
What about the BCM43231?
There was some plans about it:
http://lists.infradead.org/pipermail/b43-dev/2012-January/002297.html

But the thread ends and then it seem that nothing was achieved.

I've a BCM43231:
Bus 001 Device 008: ID 0846:9020 NetGear, Inc. WNA3100(v1) Wireless-N
300 [Broadcom BCM43231]

Are there some wireless kernels developers in Italy or in France that
would accept a bcm43231 card in exchange of working on a driver?

Denis.


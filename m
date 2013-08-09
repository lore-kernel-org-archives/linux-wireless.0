Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51662 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3HICzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 22:55:49 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20996.22876.834304.94010@gargle.gargle.HOWL> (sfid-20130809_045555_391908_541033A5)
Date: Fri, 9 Aug 2013 08:22:12 +0530
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	"ath9k_htc_fw" <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: FUSB200 xhci issue
In-Reply-To: <201308090006.07690.chunkeey@googlemail.com>
References: <Pine.LNX.4.44L0.1308081617010.1120-100000@iolanthe.rowland.org>
	<201308090006.07690.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> So, if we call usb_reset_device there and the driver is unbound
> and later rebound. the next ath9k_htc .probe will start again and
> again and again not knowing that it is already initialized 
> (and we have a loop).

The HW/FW is buggy and this workaround is required:
http://marc.info/?l=linux-usb&m=127960864905646&w=2

Sujith

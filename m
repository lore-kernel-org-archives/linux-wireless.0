Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:48319 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756210AbZDTXEX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 19:04:23 -0400
Message-ID: <20090420225740.25307.qmail@cdy.org> (sfid-20090421_010427_933670_ECFF08B8)
Date: Tue, 21 Apr 2009 00:57:40 +0200
From: Peter Stuge <stuge-linux-pcmcia@cdy.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>,
	Jack Schneider <puck@dp-indexing.com>
Subject: Re: Problem with exclusive interrupt in hostap_cs
References: <20090420101340.142b6bc6@dp-indexing.com> <49ECCABE.40805@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49ECCABE.40805@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> I would have no problem changing the driver interrupt registration
> in the link->irq structure, but I was not quite sure how change
> prism2_interrupt() to detect the shared case when the interrupt
> status register is 0xFFFF.

Another option would be for Jack to try the orinoco_cs driver.


//Peter

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:57221 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755853Ab2AIWZs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 17:25:48 -0500
Message-ID: <20120109222544.11008.qmail@stuge.se> (sfid-20120109_232551_265507_46A50874)
Date: Mon, 9 Jan 2012 23:25:44 +0100
From: Peter Stuge <peter@stuge.se>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Abimanyu Gottumukkala <me@abimanyu.in>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: BCM43231
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com> <CACna6rzA6ix2PrZDHXQLTDQuo942urtUAWYagDC0x9zANSVNKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzA6ix2PrZDHXQLTDQuo942urtUAWYagDC0x9zANSVNKQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> I've been using "usbmon" to dump traffic.

The tool at http://people.redhat.com/zaitcev/linux/usbmon-6.tar.gz
and not simply cat on the usbmon files in debugfs I hope.

debugfs only shows the first bytes of long transfers, but the API
used by the usbmon-6 tool shows complete traffic.


//Peter

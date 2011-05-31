Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57475 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab1EaPy0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 11:54:26 -0400
Received: from public by plane.gmane.org with local (Exim 4.69)
	(envelope-from <public@plane.gmane.org>)
	id 1QRRGz-0004xr-93
	for linux-wireless@vger.kernel.org; Tue, 31 May 2011 17:54:25 +0200
From: Andreas Schwab <schwab@linux-m68k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?=
	<public-zajec5-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
	Michael =?utf-8?Q?B=C3=BCsch?=
	<public-mb-fseUSCV1ubazQB+pC5nmwQ@plane.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
	"John W. Linville"
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@plane.gmane.org>,
	public-b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@plane.gmane.org,
	linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ssb: pci: implement serdes workaround
References: <1301657212-12126-1-git-send-email-zajec5@gmail.com>
	<m2vcwr9pn8.fsf@linux-m68k.org> <4DE505C6.8020601@lwfinger.net>
Date: Tue, 31 May 2011 17:54:08 +0200
In-Reply-To: <4DE505C6.8020601@lwfinger.net> (Larry Finger's message of "Tue,
	31 May 2011 10:14:14 -0500")
Message-ID: <m3wrh6hnmn.fsf@linux-m68k.org> (sfid-20110531_175530_000653_82AEA9BE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Larry Finger <Larry.Finger@lwfinger.net> writes:

> From the traceback, it must be the serdes_pll_device read that failed.

Why not ssb_pcicore_polarity_workaround (note r4 == 0x134)?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."


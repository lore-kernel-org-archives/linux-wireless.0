Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47243 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994Ab1EaQR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 12:17:27 -0400
Received: from public by plane.gmane.org with local (Exim 4.69)
	(envelope-from <public@plane.gmane.org>)
	id 1QRRdE-0004Zq-Nk
	for linux-wireless@vger.kernel.org; Tue, 31 May 2011 18:17:24 +0200
Message-ID: <4DE51487.1000808@lwfinger.net> (sfid-20110531_181731_156802_E2276B9C)
Date: Tue, 31 May 2011 11:17:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?=
	<public-zajec5-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
	=?UTF-8?B?TWljaGE=?= =?UTF-8?B?ZWwgQsO8c2No?=
	<public-mb-fseUSCV1ubazQB+pC5nmwQ@plane.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
	"John W. Linville"
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@plane.gmane.org>,
	public-b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@plane.gmane.org,
	linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ssb: pci: implement serdes workaround
References: <1301657212-12126-1-git-send-email-zajec5@gmail.com>	<m2vcwr9pn8.fsf@linux-m68k.org> <4DE505C6.8020601@lwfinger.net> <m3wrh6hnmn.fsf@linux-m68k.org>
In-Reply-To: <m3wrh6hnmn.fsf@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/31/2011 10:54 AM, Andreas Schwab wrote:
> Larry Finger<Larry.Finger@lwfinger.net>  writes:
>
>>  From the traceback, it must be the serdes_pll_device read that failed.
>
> Why not ssb_pcicore_polarity_workaround (note r4 == 0x134)?

Mainly because the last two steps in the traceback are

[c2ca5c40] [f2146244] ssb_pcie_read+0x4c/0x54 [ssb]
[c2ca5c50] [f2146440] ssb_pcicore_serdes_workaround+0x1c/0x170 [ssb]

Larry





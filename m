Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50078 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767Ab1EaRHi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 13:07:38 -0400
Received: from public by plane.gmane.org with local (Exim 4.69)
	(envelope-from <public@plane.gmane.org>)
	id 1QRSPn-0004Tg-6c
	for linux-wireless@vger.kernel.org; Tue, 31 May 2011 19:07:35 +0200
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
	<m3wrh6hnmn.fsf@linux-m68k.org> <4DE51487.1000808@lwfinger.net>
Date: Tue, 31 May 2011 19:07:19 +0200
In-Reply-To: <4DE51487.1000808@lwfinger.net> (Larry Finger's message of "Tue,
	31 May 2011 11:17:11 -0500")
Message-ID: <m239jukddk.fsf@igel.home> (sfid-20110531_190741_544567_0F999BC3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 05/31/2011 10:54 AM, Andreas Schwab wrote:
>> Larry Finger<Larry.Finger@lwfinger.net>  writes:
>>
>>>  From the traceback, it must be the serdes_pll_device read that failed.
>>
>> Why not ssb_pcicore_polarity_workaround (note r4 == 0x134)?
>
> Mainly because the last two steps in the traceback are
>
> [c2ca5c40] [f2146244] ssb_pcie_read+0x4c/0x54 [ssb]
> [c2ca5c50] [f2146440] ssb_pcicore_serdes_workaround+0x1c/0x170 [ssb]

Which exactly is what ssb_pcicore_polarity_workaround is doing.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."


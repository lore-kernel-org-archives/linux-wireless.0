Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3299 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYGaRC3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 13:02:29 -0400
Date: Thu, 31 Jul 2008 12:50:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-ID: <20080731165054.GA14485@tuxdriver.com> (sfid-20080731_190234_643979_2082E34D)
References: <4891D1B9.70703@imap.cc> <1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4891E97C.1060302@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 31, 2008 at 06:34:04PM +0200, Tilman Schmidt wrote:
> Johannes Berg schrieb:
>> On Thu, 2008-07-31 at 16:52 +0200, Tilman Schmidt wrote:
>>> Commit 782e70c6fc2290a0395850e8e02583b8b62264d8, which went into
>>> 2.6.25, broke AVM's closed-source driver for this device:
>>>
>>> ID 057c:62ff AVM GmbH WLAN USB v1.1 (cdrom mode)
>>> ID 057c:6201 AVM GmbH WLAN USB v1.1
>>>
>>> Is there an open source alternative for that driver, or do systems
>>> with that device have to stay with kernel 2.6.24?
>>
>> Never heard of any such driver, what chip does it contain?
>
> I don't know. How can I find out?
> (Preferably without cracking the thing open. ;-)
>
> http://acx100.sourceforge.net/matrix.html claims "Chipset TNETW1450"
> and "support should be quite easy" - but that entry is two years old
> and the "Model" link doesn't work, so I'm not sure how far that can
> be trusted.

Did the acx100 driver work with your card?

John
-- 
John W. Linville
linville@tuxdriver.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37788 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab2JUQfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 12:35:16 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
	<20121011203112.GB3317@kroah.com> <87haq017wi.fsf@purkki.adurom.net>
	<20121012143355.GA25235@tuxdriver.com>
	<87a9vr0w4d.fsf@purkki.adurom.net> <5079419E.20104@gmail.com>
Date: Sun, 21 Oct 2012 19:35:12 +0300
In-Reply-To: <5079419E.20104@gmail.com> (Pontus Fuchs's message of "Sat, 13
	Oct 2012 12:25:34 +0200")
Message-ID: <87liezzsu7.fsf@purkki.adurom.net> (sfid-20121021_183521_457630_0BB93B9E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pontus Fuchs <pontus.fuchs@gmail.com> writes:

> On 2012-10-13 07:38, Kalle Valo wrote:
>> But after a more thorough review I still think that this driver should
>> go to drivers/net/wireless. For example, it has proper endian support,
>> it's both gcc and sparse warning free and the code is a pleasure to
>> read(!).
> Thanks for the feedback. I'm heavily inspired by the wl12xx code so I guess
> the style suites you :)

Haha, then it's no wonder I liked it so much ;

>> * defines inside structures is not common, kernel style is to have the
>>    defines on top of the structure definition
>>
>
> Hmmm. That's legacy from the FreeBSD driver. All those structs are
> copy-pasted from here:
>
> http://svn.freebsd.org/base/stable/9/sys/dev/usb/wlan/if_uathreg.h
>
> I would prefer to keep as close as possible to that file but if it's
> an issue I can certainly change that.

This isn't an issue, it's just style I don't like. But you as the
maintainer have the final call.

-- 
Kalle Valo

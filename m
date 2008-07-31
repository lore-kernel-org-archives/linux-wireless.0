Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:59917 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbYGaOPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 10:15:15 -0400
Received: by an-out-0708.google.com with SMTP id d40so90875and.103
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 07:15:15 -0700 (PDT)
Message-ID: <bc64b4640807310715j41bb0029i5c8be73a311ed52@mail.gmail.com> (sfid-20080731_161523_701288_C6B1DFAE)
Date: Thu, 31 Jul 2008 18:15:14 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: Driver for the FullMAC card
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1217512488.12016.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <g6qr98$q28$2@ger.gmane.org>
	 <1217512488.12016.8.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/31 Dan Williams <dcbw@redhat.com>:
> On Wed, 2008-07-30 at 22:51 +0000, Dmitry Baryshkov wrote:
>> Hi,
>>
>> I'd like to work on the Prism2 USB driver (currently maintained as a part of
>> wlan-ng project) to be able to push it into mainline. The card itself is
>> a FullMAC card. Where should I start? What parts of 802.11 stacks/API
>> should I use? There is plenty of information regarding SoftMAC drivers,
>> but no clear pointers for developing drivers for the FullMAC cards.
>
> If you're talking about the same hardware that linux-wlan-ng supported
> (ie, what Ubuntu ships as prism2_usb) then that hardware can be softmac,
> actually.  We discussed this a while ago and agreed that a completely
> new mac80211-based driver for this hardware was the best way to go,
> rather than trying to stuff USB support into hostap.

Yes, I was talking about prism2_usb cards. I'll explore how to switch it to
the softmac.


-- 
With best wishes
Dmitry

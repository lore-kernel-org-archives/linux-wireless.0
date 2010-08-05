Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34086 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab0HETBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 15:01:09 -0400
Received: by wyb39 with SMTP id 39so6966394wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 12:01:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C5ADA52.40106@lwfinger.net>
References: <AANLkTi=Q7FXWnH9dyH3mPX7G+JDBNVb0NWuYjqd_VN2F@mail.gmail.com>
	<4C5AC2B1.7060007@lwfinger.net>
	<AANLkTinrj6ApbFz5_3T95Z96RBbuz5hTh3x=Q98qpgpP@mail.gmail.com>
	<4C5ADA52.40106@lwfinger.net>
Date: Thu, 5 Aug 2010 16:01:07 -0300
Message-ID: <AANLkTi=2qk6GExYE+daK4XHT5B22LpQxNZOdsrMrsmUx@mail.gmail.com>
Subject: Re: bdm 4353 802.11n monitor mode you can?
From: Arthur Moreira <arthur.moreira@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tk Larry
I will wait
I am from brazil and to buy in ebay is complicated
but, i will look in mercadolivre com br the symilar in brazil
but i dont want to buy a extra card for mobility, but i will see

i will wait the guys try to correct the wl driver.
tks all

off corse, sorry for my bad english.

              Arthur Moreira




2010/8/5 Larry Finger <Larry.Finger@lwfinger.net>:
> On 08/05/2010 09:38 AM, Arthur Moreira wrote:
>> Tks Larry
>> I willl wait, the broadcom support team call for look the dell. And
>> the dell only windows driver.
>>
>> Larry i need much to can make a scan in networks, i work with network
>> secutiry and buyed a dell laptop, without knowing that it would take
>> this job.
>>
>> what you can do to help me or guide me I appreciate.
>>
>> you who work with creating the modules and drivers can not create a
>> module to put the card 802.11n broadcom 4353 chipset in monitor mode?
>> and packet injection?
>
> You can certainly use ndiswrapper and the Windows driver. My only question would
> be the stability of that configuration.
>
> Your other option would be to purchase a USB device that does support monitor
> mode. My favorite is the Netgear WG111V2, which uses the rtl8187 driver. These
> are available for ~$10 on Ebay. Any device that uses mac80211 should be capable
> of monitor mode. If you want both 2.4 and 5 GHz bands, then you can use a Dell
> Wireless 1450 USB adapter (Model D1450U). There is one on Ebay for $21.
>
> Reverse-engineering a complicated device like the Broadcom 802.11n chips is not
> trivial. We get no specifications or any help from Broadcom. Yes, we will be
> able to provide a driver with full capabilities; however, I have no idea when
> that will happen.
>
> Please do a "Reply-to-all" so that the mailing list archives have the full
> record of our mails.
>
> Larry
>
>
>

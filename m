Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62425 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933588Ab0HEPfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 11:35:47 -0400
Received: by ewy23 with SMTP id 23so2431859ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 08:35:46 -0700 (PDT)
Message-ID: <4C5ADA52.40106@lwfinger.net>
Date: Thu, 05 Aug 2010 10:35:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arthur Moreira <arthur.moreira@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: bdm 4353 802.11n monitor mode you can?
References: <AANLkTi=Q7FXWnH9dyH3mPX7G+JDBNVb0NWuYjqd_VN2F@mail.gmail.com>	<4C5AC2B1.7060007@lwfinger.net> <AANLkTinrj6ApbFz5_3T95Z96RBbuz5hTh3x=Q98qpgpP@mail.gmail.com>
In-Reply-To: <AANLkTinrj6ApbFz5_3T95Z96RBbuz5hTh3x=Q98qpgpP@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/05/2010 09:38 AM, Arthur Moreira wrote:
> Tks Larry
> I willl wait, the broadcom support team call for look the dell. And
> the dell only windows driver.
> 
> Larry i need much to can make a scan in networks, i work with network
> secutiry and buyed a dell laptop, without knowing that it would take
> this job.
> 
> what you can do to help me or guide me I appreciate.
> 
> you who work with creating the modules and drivers can not create a
> module to put the card 802.11n broadcom 4353 chipset in monitor mode?
> and packet injection?

You can certainly use ndiswrapper and the Windows driver. My only question would
be the stability of that configuration.

Your other option would be to purchase a USB device that does support monitor
mode. My favorite is the Netgear WG111V2, which uses the rtl8187 driver. These
are available for ~$10 on Ebay. Any device that uses mac80211 should be capable
of monitor mode. If you want both 2.4 and 5 GHz bands, then you can use a Dell
Wireless 1450 USB adapter (Model D1450U). There is one on Ebay for $21.

Reverse-engineering a complicated device like the Broadcom 802.11n chips is not
trivial. We get no specifications or any help from Broadcom. Yes, we will be
able to provide a driver with full capabilities; however, I have no idea when
that will happen.

Please do a "Reply-to-all" so that the mailing list archives have the full
record of our mails.

Larry



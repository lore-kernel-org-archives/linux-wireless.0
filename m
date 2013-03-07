Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42531 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab3CGQy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 11:54:29 -0500
Received: by mail-oa0-f43.google.com with SMTP id l10so849097oag.30
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 08:54:28 -0800 (PST)
Message-ID: <5138C641.5030004@lwfinger.net> (sfid-20130307_175434_884089_F1BDD0EE)
Date: Thu, 07 Mar 2013 10:54:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?S8OpdmluIFRISUVSUlk=?= <kevinthierry@myopera.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: Unable to activate WiFi p2p / WiFi Direct
References: <1362663176.11919.140661201212753.170BABA0@webmail.messagingengine.com> <1362666346.22280.140661201248433.42E3B535@webmail.messagingengine.com>
In-Reply-To: <1362666346.22280.140661201248433.42E3B535@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2013 08:25 AM, Kévin THIERRY wrote:
> Hi,
> I've been unable to activate the p2p feature on my WiFi dongle (which
> otherwise works fine).
> iwpriv command returns "wlan1 no private ioctls."
> I'm running Ubuntu 12.04 with kernel 3.5.0-25 and the WiFi dongle is a
> Netgear model wna1000m (driver rtl8192cu).
> I've also tried with kernel 3.8.2 with the same result.
> Thanks,

P2P is not yet implemented in rtl8192cu. The method is being added to rtlwifi 
and the PCI-based drivers in patches that are now undergoing tests. They will 
likely be in kernel 3.10. Once that is done, I will be able to consider P2P for 
the USB-based driver.

FWIW, the use of iwpriv for things like this has been discontinued. Check the 
use of iw.

Larry



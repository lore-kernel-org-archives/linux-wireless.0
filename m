Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36929 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbZIHPU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 11:20:28 -0400
Received: by bwz19 with SMTP id 19so2283519bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 08:20:30 -0700 (PDT)
Message-ID: <4AA67009.4020400@lwfinger.net>
Date: Tue, 08 Sep 2009 09:54:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	netrolller.3d@gmail.com, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: b43 dma error
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de>
In-Reply-To: <200909081638.36897.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
>> I tested wireless-testing b43 driver, but got "Fatal DMA error"
>> then the controller keep restarting...
>>
>> Please tell what I can provide or test, Thanks.
> 
> Is this a regression? If so, please bisect.

It is something specific to his system as I don't see anything like
this. In addition, there are some users on the openSUSE forums that
have implemented the latest compat-wireless and switched away from
Broadcom wl to b43 on their LP PHY devices. So far, no complaints from
them.

Please reboot so that we see the ssb output as well. Use the command

dmesg | egrep "ssb|b43"

That way we will be able to see exactly what kind of device you have
and what revisions are in it. AFAIK, the testing to date has been
limited to Rev 1 PHYs and Rev 2 radios.

Larry



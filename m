Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:27498 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbZHVFmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 01:42:03 -0400
Received: by fg-out-1718.google.com with SMTP id e21so282466fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 22:42:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250858409.5137.2.camel@johannes.local>
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>
	 <4A8E8F59.9050706@lwfinger.net>
	 <1250858409.5137.2.camel@johannes.local>
Date: Sat, 22 Aug 2009 13:42:03 +0800
Message-ID: <f42a38140908212242h1ce0339fw1243dbacf54000ab@mail.gmail.com>
Subject: Re: Abour linux driver supports BCM4325
From: feng tian <feng.of.tian@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of waiting for the codes, we decide to do someting on
supporting the BCM 4325 running in linux via SDIO.
The linux wireless dirver supports another chip (marvel 8686) with
SDIO interface, the sources codes locate in
drivers/net/wireless/libertas.
We are wondering to develop the BCM4325 driver in the reference to the
marvel 8686 SDIO driver.
Please give comments on this, thanks.

BR
Feng

2009/8/21 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2009-08-21 at 07:13 -0500, Larry Finger wrote:
>
>> > We are working on a project which supports the BCM4325 linux wireless
>> > driver. The interface between the BCM chip and SOC(pxa310) is SDIO.
>> > I did some searches online and found that there is no available driver
>> > for this chip. Do I have to implement this myself? Is there anyone can
>> > provide us some related materials?  Thanks very much.
>>
>> The code for the LP PHY, which I believe is present in the 4325, is
>> just being written. At the moment, the chip is able to receive on some
>> channels, and may be able to transmit. These results are reported on
>> this mailing list, and the code is being applied to the wireless
>> testing git tree.
>
> Also, somebody is working on SDIO support with Michael.
>
> johannes
>

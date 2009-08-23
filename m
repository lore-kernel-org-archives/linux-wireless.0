Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:48706 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933425AbZHWC1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 22:27:54 -0400
Received: by fg-out-1718.google.com with SMTP id e21so355503fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 19:27:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250964823.23605.22.camel@johannes.local>
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>
	 <4A8E8F59.9050706@lwfinger.net>
	 <1250858409.5137.2.camel@johannes.local>
	 <f42a38140908212242h1ce0339fw1243dbacf54000ab@mail.gmail.com>
	 <4A90005B.3030101@lwfinger.net>
	 <1250964823.23605.22.camel@johannes.local>
Date: Sun, 23 Aug 2009 10:27:54 +0800
Message-ID: <f42a38140908221927qabc3f25t60f348f7c4a446c9@mail.gmail.com>
Subject: Re: Abour linux driver supports BCM4325
From: feng tian <feng.of.tian@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for the information.
I get your point. As for the radio and phy driver, I think it's  some
command based configurations for the chip via SDIO. And that I can
refer to the BCM 43xx PCI driver codes.
Wonder if it's feasible. Needs your comments.
Thanks

BR
Feng

2009/8/23 Johannes Berg <johannes@sipsolutions.net>:
> On Sat, 2009-08-22 at 09:27 -0500, Larry Finger wrote:
>> feng tian wrote:
>> > Instead of waiting for the codes, we decide to do someting on
>> > supporting the BCM 4325 running in linux via SDIO.
>> > The linux wireless dirver supports another chip (marvel 8686) with
>> > SDIO interface, the sources codes locate in
>> > drivers/net/wireless/libertas.
>> > We are wondering to develop the BCM4325 driver in the reference to the
>> > marvel 8686 SDIO driver.
>> > Please give comments on this, thanks.
>>
>> The SDIO routines might be transferable; however, the radio and PHY
>> code will be completely different.
>
> Very few of them will be, afaict the SDIO bus access is vastly
> different. Learning how to write an SDIO driver might be possible, but I
> suspect transferring code won't make much sense.
>
> Either way, isobel has some b43 sdio code already.
>
> johannes
>

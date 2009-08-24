Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51358 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbZHXGDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 02:03:11 -0400
Received: by bwz19 with SMTP id 19so1284786bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2009 23:03:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f42a38140908230830r45ef1d01l5a9c5a4d0197e81e@mail.gmail.com>
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>
	 <4A90B086.1020503@lwfinger.net>
	 <1251018830.23605.32.camel@johannes.local>
	 <200908231455.51140.mb@bu3sch.de>
	 <f42a38140908230830r45ef1d01l5a9c5a4d0197e81e@mail.gmail.com>
Date: Mon, 24 Aug 2009 14:03:12 +0800
Message-ID: <f42a38140908232303j320f858cw5c0e45cc98a1e440@mail.gmail.com>
Subject: Re: Abour linux driver supports BCM4325
From: feng tian <feng.of.tian@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>  1) changing b43 so it knows how to talk not just to SSB/PCI/PCMCIA
>>>     chips but also SDIO chips
>>
>> We already have working support for that and we're currently merging it mainline.
>> If you want to help, please test the spinlock removal patchset I just posted.

>>>  2) changing b43 so it knows how to talk to your specific radio/PHY
>>>     chip, and LP PHY

Where can I get theses codes which supports b43 talking to SDIO chips?
Thanks very much.

BR, Feng

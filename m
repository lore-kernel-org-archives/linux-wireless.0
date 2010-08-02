Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0HBJ3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 05:29:23 -0400
Received: by pwi5 with SMTP id 5so1276738pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 02:29:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C5683C9.1090504@linux.intel.com>
References: <4C54ACE7.1000205@linux.intel.com>
	<AANLkTin5jKr4BQdxooy4NRjmBja2Z8TPdgE-5RV++AQh@mail.gmail.com>
	<4C5683C9.1090504@linux.intel.com>
Date: Mon, 2 Aug 2010 12:29:22 +0300
Message-ID: <AANLkTinY54ZasK_-2Hfdj1uAqg6RXMjyEOr+98gRzAyM@mail.gmail.com>
Subject: Re: Regulatory domain
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Sebastien Cayetanot <sebastien.cayetanot@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> (aaaa-bbbb @ c),(n/a, 23), XXX
>>
>> each line is a range in frequencies (channels that fall between aaaa
>> and bbbb. c is the channel width (10 Mhz for Japan's narrow channels,
>> 20 Mhz for regular channels and 40 Mhz for wide channels). 23 is the
>> maximum Tx power e.i.r.p. in db.
>
> Many thanks for your support and the link. One additional parameter 'N/A' is
> my example are sometimes fills w/ a number depending on the country I set.
>
> What is the meaning of this parameter, I didn't catch it on the Regulatory
> page.

It is the maximum antenna gain: look at
http://wireless.kernel.org/en/developers/Regulatory/Database and click
on one of the countries there.

>
> Thx
>
> Sebastien
>

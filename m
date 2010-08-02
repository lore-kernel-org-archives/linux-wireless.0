Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55446 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab0HBIhb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 04:37:31 -0400
Message-ID: <4C5683C9.1090504@linux.intel.com>
Date: Mon, 02 Aug 2010 10:37:29 +0200
From: Sebastien Cayetanot <sebastien.cayetanot@linux.intel.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Regulatory domain
References: <4C54ACE7.1000205@linux.intel.com> <AANLkTin5jKr4BQdxooy4NRjmBja2Z8TPdgE-5RV++AQh@mail.gmail.com>
In-Reply-To: <AANLkTin5jKr4BQdxooy4NRjmBja2Z8TPdgE-5RV++AQh@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 8/1/2010 8:08 AM, Emmanuel Grumbach wrote:
>> country JP:
>>         (2402 - 2472 @ 40), (N/A, 20)
>>         (2457 - 2482 @ 20), (N/A, 20)
>>         (2474 - 2494 @ 20), (N/A, 20), NO-OFDM
>>         (4910 - 4930 @ 10), (N/A, 23)
>>         (4910 - 4990 @ 40), (N/A, 23)
>>         (4930 - 4950 @ 10), (N/A, 23)
>>         (5030 - 5045 @ 10), (N/A, 23)
>>         (5030 - 5090 @ 40), (N/A, 23)
>>         (5050 - 5060 @ 10), (N/A, 23)
>>         (5170 - 5250 @ 40), (N/A, 20)
>>         (5250 - 5330 @ 40), (N/A, 20), DFS
>>         (5490 - 5710 @ 40), (N/A, 23), DFS
>>
>> I would like to understand exactly what is displayed.
>>
>> - the number of line (xxx-xxx @ xx), (xx,xx) is equal to the number of channel which can be accessed
>> - What is the meaning of each line and details on each parameter.
>>
> http://wireless.kernel.org/en/developers/Regulatory
>
> (aaaa-bbbb @ c),(n/a, 23), XXX
>
> each line is a range in frequencies (channels that fall between aaaa
> and bbbb. c is the channel width (10 Mhz for Japan's narrow channels,
> 20 Mhz for regular channels and 40 Mhz for wide channels). 23 is the
> maximum Tx power e.i.r.p. in db.
Many thanks for your support and the link. One additional parameter 
'N/A' is my example are sometimes fills w/ a number depending on the 
country I set.

What is the meaning of this parameter, I didn't catch it on the 
Regulatory page.

Thx

Sebastien

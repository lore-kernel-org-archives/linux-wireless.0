Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from embla.aitel.hist.no ([158.38.50.22]:52839 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYCILwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 07:52:13 -0400
Message-ID: <47D3D060.5080801@mail.aitel.hist.no> (sfid-20080309_115218_079043_8D28619C)
Date: Sun, 09 Mar 2008 12:56:16 +0100
From: Helge Hafting <helgehaf@mail.aitel.hist.no>
MIME-Version: 1.0
To: Anders Eriksson <aeriksson@fastmail.fm>
CC: Tomas Winkler <tomasw@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 associated and _worked_ with a *wrong* essid!
References: <47CE8ED6.7030302@aitel.hist.no> <1ba2fa240803050749j8bb291ajb8a0451504a0b905@mail.gmail.com> <20080308103831.0CBFE93C070@tippex.mynet.homeunix.org>
In-Reply-To: <20080308103831.0CBFE93C070@tippex.mynet.homeunix.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anders Eriksson wrote:
>> I recently wrote about my iwl3945 problems - I usually
>>  have to try 20-50 times before I can use a wep-encrypted access point.
>>  Once the link goes up - no more problems. But getting the first
>>  connection takes time.
>>     
>
> I can testify that I have the same issue with w2k. I'm not sure how intel 
> wired up their drivers package, but I usually have to wait about 1-2 minutes 
> to get _any_ package back from the AP (judging from the network icon). Once I 
> get the first package back (I'd guess it's a dhcp resp), i can start using the 
> network.
>   
The linux driver (with the siwessid/siwencode patch) is better than that 
now.
It may connect at first try, always at the second or third try. 3 tries only
takes a few seconds. So it is possible to get this right. Hopefully it 
can be fixed
further, to always work at first try.

Helge Hafting

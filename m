Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:39540 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbYFMNVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 09:21:17 -0400
Received: from poczta.interia.pl (mi01.poczta.interia.pl [10.217.12.1])
	by smtp239.poczta.interia.pl (INTERIA.PL) with ESMTP id 9BC0231AA55
	for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 15:21:14 +0200 (CEST)
Received: from [192.168.1.7] (d90-129-241-239.cust.tele2.pl [90.129.241.239])
	by poczta.interia.pl (INTERIA.PL) with ESMTP id 151F17698A2
	for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 15:21:14 +0200 (CEST)
Message-ID: <4852745B.9030007@interia.pl> (sfid-20080613_152121_303876_6DBDBB4F)
Date: Fri, 13 Jun 2008 15:21:31 +0200
From: Maciek Kaliszewski <mkalkal@interia.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 and WPA
References: <4852658A.4040402@interia.pl> <1ba2fa240806130557s16f8ef99y639e4a1287c4f718@mail.gmail.com>
In-Reply-To: <1ba2fa240806130557s16f8ef99y639e4a1287c4f718@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
>
>> Invalid freq in scan results (BSSID=00:00:01:00:00:1d m=0 e=11)
>> Invalid freq in scan results (BSSID=00:00:01:00:00:1d m=0 e=2462)
>>     
>
> What system kernel are you using. This looks something we've already solved...
> Tomas
> --
>   
Kernel is
uname -a
Linux debian 2.6.24.2 #1 SMP Mon Feb 11 10:22:07 UTC 2008 x86_64 GNU/Linux

I've used iwl3945 driver included in this kernel , but also I've tried 
compat-wireless-2008-06-13 . No change.

Regards
Maciek Kaliszewski



----------------------------------------------------------------------
Podbij Dziki Zachod!Gra strategiczna online
Sprawdz >>> http://link.interia.pl/f1dff


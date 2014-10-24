Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32807 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaJXTFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 15:05:36 -0400
Received: by mail-wi0-f174.google.com with SMTP id q5so2013950wiv.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 12:05:35 -0700 (PDT)
Received: from [10.5.50.110] (105-236-80-71.access.mtnbusiness.co.za. [105.236.80.71])
        by mx.google.com with ESMTPSA id ey6sm2927431wib.16.2014.10.24.12.05.33
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Oct 2014 12:05:34 -0700 (PDT)
Message-ID: <544AA2F9.6050806@gmail.com> (sfid-20141024_210539_691167_B169FF47)
Date: Fri, 24 Oct 2014 21:05:29 +0200
From: jeremy lansman <jeremy.lansman@gmail.com>
Reply-To: jeremy.lansman@gmail.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Channel Estimation Question
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

I beg your pardon for asking a newbe question...but..here goes anyway.

My problem is with an Intel Advanced 6230.  I have noted over the year + 
I have used it under Ubuntu that it seems to have a problem when I move 
the laptop.  This is consistent with a channel estimation (tap 
equalizer) issue under COFDM modulation.
No, I do not know about wi-fi, and I do not relish digging into driver 
stuff.  But I do know digital RF in general.
If it is going to take more hoursout of my life , maybe I should buy an 
external wi-fi for the lap top and put up with the resultant klutz.

This is ping to my AP after I move about:
64 bytes from 10.5.50.1: icmp_seq=509 ttl=64 time=1057 ms
64 bytes from 10.5.50.1: icmp_seq=510 ttl=64 time=5382 ms
64 bytes from 10.5.50.1: icmp_seq=511 ttl=64 time=4386 ms
64 bytes from 10.5.50.1: icmp_seq=512 ttl=64 time=3383 ms
64 bytes from 10.5.50.1: icmp_seq=513 ttl=64 time=2376 ms
64 bytes from 10.5.50.1: icmp_seq=514 ttl=64 time=1438 ms
64 bytes from 10.5.50.1: icmp_seq=515 ttl=64 time=433 ms
64 bytes from 10.5.50.1: icmp_seq=516 ttl=64 time=823 ms
64 bytes from 10.5.50.1: icmp_seq=517 ttl=64 time=1533 ms


This is if I sit still a while:
64 bytes from 10.5.50.1: icmp_seq=583 ttl=64 time=1.18 ms
64 bytes from 10.5.50.1: icmp_seq=584 ttl=64 time=1.79 ms
64 bytes from 10.5.50.1: icmp_seq=585 ttl=64 time=0.871 ms
64 bytes from 10.5.50.1: icmp_seq=586 ttl=64 time=2.96 ms
64 bytes from 10.5.50.1: icmp_seq=587 ttl=64 time=1.28 ms
64 bytes from 10.5.50.1: icmp_seq=588 ttl=64 time=1.57 ms
64 bytes from 10.5.50.1: icmp_seq=589 ttl=64 time=1.03 ms

WIFI worked after I installed Unbuntu Trusty, but an update seems to 
have broken it, sending performance back to what it was under 12.04.

So.. do you think it might be a simple fix related to channel estimation?

Thank you.






-- 
Jeremy Lansman
New York City USA, +1 347 696 0120
Western Cape RSA, +27 21 300 2105
Anchorage AK USA,+1 907 339 3800
Skype Lansmankyes
Fax 27862460713


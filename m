Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:47738 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZGKQUO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 12:20:14 -0400
Message-ID: <4A58BBB3.3020908@wpkg.org>
Date: Sat, 11 Jul 2009 18:20:03 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath5k AP support?
References: <4A381159.70301@wpkg.org> <b6c5339f0906161454tbdaf382k654450a9f1cf8ae7@mail.gmail.com> <4A3AA08E.4050400@wpkg.org> <4A3AA20C.6020908@wpkg.org> <20090705120228.GD2132@hash.localnet>
In-Reply-To: <20090705120228.GD2132@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Thu, Jun 18, 2009 at 10:22:36PM +0200, Tomasz Chmielewski wrote:
>> Oh well.
>> The above is with hostapd 0.7.0 snapshot.
>> With 0.6.9 I can connect and the connection works fine
>>
>> Is it normal?
> 
> I'm not sure -- do you have anything in dmesg?  
> 
> I've noticed a strange bug lately where some packets to the STA get dropped
> due to some kind of off-by-u32 bug.  I haven't tracked it down yet to
> any certain combination of ath5k/w-t/hostapd, though.

No, nothing in dmesg.

I checked out 0.7 now, and it seems to work.

So, problem solved.


-- 
Tomasz Chmielewski
http://wpkg.org

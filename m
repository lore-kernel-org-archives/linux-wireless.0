Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40330 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab3C0RsK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 13:48:10 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
References: <87li993mug.fsf@sycorax.lbl.gov>
	<1364406146.8388.12.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Mar 2013 10:48:06 -0700
In-Reply-To: <1364406146.8388.12.camel@jlt4.sipsolutions.net> (message from
	Johannes Berg on Wed, 27 Mar 2013 18:42:26 +0100)
Message-ID: <87mwto20q1.fsf@sycorax.lbl.gov> (sfid-20130327_184816_932221_A28A96E0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2013-03-26 at 13:52 -0700, Alex Romosan wrote:
>> since v3.9-rc1 i have been unable to reconnect to my access point. the
>> access point is a netgear n600 and the my card is a Centrino Advanced-N
>> 6205 [Taylor Peak] (rev 34). the last kernel that worked was 3.8. when i
>> boot up the laptop the connection is established but if i bring down the
>> network with ifdown then i cannot reconnect. this is what i see in the
>> logs:
>> 
>>  iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>>  iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
>>  wlan0: authenticate with xx:xx:xx:xx:xx:xx
>>  wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
>>  wlan0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
>>  wlan0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
>>  wlan0: authentication with xx:xx:xx:xx:xx:xx timed out
>
> Btw, since we're looking at the timeout handling -- do you have a
> version of this log with timestamps on each line?

i do but the timestamp is the same on all the lines:

Mar 27 09:43:14 trinculo kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
Mar 27 09:43:14 trinculo kernel: iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
Mar 27 09:43:16 trinculo kernel: wlan0: authenticate with xx:xx:xx:xx:xx:xx
Mar 27 09:43:16 trinculo kernel: wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
Mar 27 09:43:16 trinculo kernel: wlan0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
Mar 27 09:43:16 trinculo kernel: wlan0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
Mar 27 09:43:16 trinculo kernel: wlan0: authentication with xx:xx:xx:xx:xx:xx timed out

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |

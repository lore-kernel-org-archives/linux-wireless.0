Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47890 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab1EWQyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 12:54:23 -0400
Message-ID: <4DDA913B.1060002@candelatech.com> (sfid-20110523_185429_601140_5D5A273C)
Date: Mon, 23 May 2011 09:54:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com>
In-Reply-To: <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 04:28 AM, Mohammed Shafi wrote:
> On Sat, May 21, 2011 at 3:52 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> This is on 2.6.39-wl+
>>
>> All the 5Ghz channels are showing as passive scanning, which
>> makes them unusable for APs if nothing else.
>
> for me channels 36,40,44,48 are ok in 5ghz. used the latest
> wireless-testing just brought the card up as station mode.

Most of my systems show the same, at least most of the time.


>> Any idea why this is happening?
>
> don't know, may be regulatory.

After a reboot and an idle weekend, mine also look normal.
So, it's something transient it appears.

What a pain.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


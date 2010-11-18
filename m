Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38227 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab0KRPFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 10:05:22 -0500
Received: by iwn35 with SMTP id 35so3599548iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 07:05:22 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 18 Nov 2010 16:05:20 +0100
Message-ID: <AANLkTin910W2HofnYpHn7a+g7mS0VQaJoqOq=1JrVXM4@mail.gmail.com>
Subject: [iwlwifi] Change MIMO Bit Rates
From: "An (Jack) Chan" <jackachan@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

>From linux-wireless documentation for iw, I find that setting
preferences for transmitting using MCS rates is not yet supported.
Does it mean I cannot set different MIMO rate through iw CLI?

What is the default MIMO bit rate the iwl5000 would use? I setting up
an ad-hoc connection between two laptops equipped with Intel 5300
cards with 3 antennas each. I find the bit rate is only 5.5Mbps when I
use "iw dev ah0 station dump" to check. It seems not a MIMO bit rate.

Maybe I miss something. Does anyone have any idea?

Thank you very much.

Best,

Jack


On Tue, Nov 16, 2010 at 10:45 PM, An (Jack) Chan <jackachan@gmail.com> wrote:
> Thank you very much, Johannes.
>
> I have one more question. Do you know if iwl5000 supports both
> Space-Time Block Coding (STBC) and Spatial Multiplexing (SM)? That
> means I can change the rates in both STBC and SM schemes?
>
> As I know in Ralink's RT2880, their configuration file provides an
> interface for setting different MCS values. STBC is from 0 to 7, while
> SM is from 8 to 15, and 33 is auto-rate.
>
> Jack
>
>
> On Tue, Nov 16, 2010 at 10:36 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2010-11-16 at 21:12 +0100, An (Jack) Chan wrote:
>>
>>> Does anyone know where I can find the implementation of rate
>>> adaptation in iwl5000 driver?
>>
>> It's in iwl-agn-rs.c
>>
>> johannes
>>
>>
>



-- 

Jack
http://csiflabs.cs.ucdavis.edu/~jackchan/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48018 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab1KOHIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 02:08:45 -0500
Message-ID: <4EC20F84.3000000@qca.qualcomm.com> (sfid-20111115_080849_698225_867830BD)
Date: Tue, 15 Nov 2011 12:36:44 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>
Subject: Re: [RFC 00/18] ath9k: Add support for MCI BT coex
References: <1321336840-12366-1-git-send-email-mohammed@qca.qualcomm.com> <1321339485.2408.85.camel@cumari>
In-Reply-To: <1321339485.2408.85.camel@cumari>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 November 2011 12:14 PM, Luciano Coelho wrote:
> Hi Mohammed,

Hi Luciano,

>
> On Tue, 2011-11-15 at 11:30 +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> Add support for MCI BT-Coex for AR9462. with AR9462 we have
>> WLAN and BT coexists via MCI protocol(Message Coexistence Interface)
>> WLAN and BT exchanges GPM, SCHED messages and few other messages
>> for coexistence.
>>
>> this is not yet tested and need some more review, few misc cleanups.
>> please add your review comments.
>>
>> thanks a lot to Rajkumar Manoharan<rmanohar@qca.qualcomm.com>  for
>> his suggestions, review comments, code cleanups, and modifications
>> in design.
>
> [...]
>
> Your patch emails are not being sent in a threaded form, which is a bit
> annoying.  Can you fix it? Maybe you are using --no-thread or you have
> sendemail.thread set to false in your .gitconfig?

thanks for pointing it out, I will fix it.

>


-- 
thanks,
shafi

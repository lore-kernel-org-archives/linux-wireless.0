Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([74.45.170.26]:49091 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaEANIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 09:08:52 -0400
Message-ID: <5362475C.8040308@canonical.com> (sfid-20140501_150855_637742_EB71F83C)
Date: Thu, 01 May 2014 07:08:44 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: Nicolas Vaquero <nicovaq92@hotmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Sven Eckelmann <sven@narfation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel source
References: <535E7741.1030607@lwfinger.net> <3262959.TlL8alHHte@bentobox> <53610B15.4000607@lwfinger.net> <BLU0-SMTP5388FC10A36BF1D90FE79FA9410@phx.gbl>
In-Reply-To: <BLU0-SMTP5388FC10A36BF1D90FE79FA9410@phx.gbl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like there is already a bug report in progress for this:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1289429

I'll attach the patch and have Joe build a test kernel.

rtg

On 04/30/2014 11:50 AM, Nicolas Vaquero wrote:
> If you want, I can reinstall Ubuntu 12.04 and update it to the lastest
> Kernel version from Update Manager.
> Teach me how to make a Bug Report and I'll send it to you.
> (Sorry for my English, maybe your eyes are bleeding)
> 
> Nicolas
> 
> El 30/04/14 11:39, Larry Finger escribió:
>> Sven and Tim,
>>
>> Attached is a one-line fix for the problem that shows up between
>> 3.8.0-36 and 3.8.0-37. It is just a bare patch file, but feel free to
>> add any explanatory text to make it a proper commit.
>>
>> I have no real understanding as to why this line of code does not
>> cause any problems with later kernel versions, but it does here. In
>> addition, I have not had any reports of problems with other users.
>> That makes me suspect some kind of bad interaction with the user-space
>> network control components in 12.04.
>>
>> Would it be helpful for Nicolas to prepare a bug report at Ubuntu?
>>
>> Larry
>>
>>
> 
-- 
Tim Gardner tim.gardner@canonical.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbcEaPED (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 11:04:03 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
	<wrfjinyayf2i.fsf@redhat.com>
Date: Tue, 31 May 2016 11:04:02 -0400
In-Reply-To: <wrfjinyayf2i.fsf@redhat.com> (Jes Sorensen's message of "Wed, 18
	May 2016 22:08:53 -0400")
Message-ID: <wrfjwpmagtgd.fsf@redhat.com> (sfid-20160531_170408_538913_6271760E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Dan Lenski <dlenski@gmail.com> writes:
>> Here is a patch to increase the polling timeout for rtl8xxxu firmware
>> startup.
>>
>> This patch now applies cleanly to Jes Sorensen's rtl8xxxu-devel tree
>> (86c89dd4782030c4f9e0c82424a8b92f9fdb35aa).
>>
>> The patch to make this a module parameter was removed.
>>
>> Dan Lenski (1):
>>   rtl8xxxu: Increase default polling timeout for firmware startup
>>
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Dan,
>
> Thanks for the patch, I'll apply it shortly.

Dan,

Given your follow-on discoveries, do you still want me to apply the poll
timeout patch, or should we wait until we nail down the reset code issue
first?

Cheers,
Jes

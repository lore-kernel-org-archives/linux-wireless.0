Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:1298 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaIKUkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 16:40:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: support firmware crash-by-assert
References: <20140910155928.30418.45160.stgit@potku.adurom.net>
	<54107D90.7080907@candelatech.com>
Date: Thu, 11 Sep 2014 23:40:26 +0300
In-Reply-To: <54107D90.7080907@candelatech.com> (Ben Greear's message of "Wed,
	10 Sep 2014 09:34:24 -0700")
Message-ID: <874mwd3n7p.fsf@kamboji.qca.qualcomm.com> (sfid-20140911_224047_854910_15AF3E99)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 09/10/2014 08:59 AM, Kalle Valo wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> 10.1 firmware does not have an official way to
>> cause assert on purpose, but it can be done with
>> carefully crafted WMI command.  This is a different
>> kind of crash from the 'hard' crash, which is
>> a bad memory dereference.
>>
>> Different crashes decode in different manners, so
>> this will help the crash-report testing as well as
>> offer better ways to test firmware failure and
>> recovery.
>>
>> kvalo: move the wmi command creation to debug.c, modify
>> the info print
>
> This looks fine to me.  I have not tested this version.

I did test it and seems to work as it should.

-- 
Kalle Valo

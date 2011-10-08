Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39691 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1JHXAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 19:00:10 -0400
Received: by ywb5 with SMTP id 5so4526687ywb.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 16:00:10 -0700 (PDT)
Message-ID: <4E90D5F7.6020005@lwfinger.net> (sfid-20111009_010023_151669_9F8FA65D)
Date: Sat, 08 Oct 2011 18:00:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net> <1318113514.1844.34.camel@Joe-Laptop>
In-Reply-To: <1318113514.1844.34.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/2011 05:38 PM, Joe Perches wrote:
> On Sat, 2011-10-08 at 17:28 -0500, Larry Finger wrote:
>> The kernel now contains library routines to establish crc8 tables and
>> to calculate the appropriate sums. Use them for ssb.
> []
>> --- wireless-testing-new.orig/drivers/ssb/pci.c
> []
>> +static inline void ltoh16_buf(u16 *buf, unsigned int size)
>
> Perhaps a rename and use le16_to_cpup?
>
>> +static inline void htol16_buf(u16 *buf, unsigned int size)
>
> and cpu_to_le16p?

I'm sorry, but I don't see any advantage to using a pointer version here. Please 
enlighten me.

Thanks,

Larry

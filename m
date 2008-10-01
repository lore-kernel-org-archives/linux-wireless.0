Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:55706 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYJATAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 15:00:51 -0400
Received: by yx-out-2324.google.com with SMTP id 8so121914yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 12:00:49 -0700 (PDT)
Message-ID: <43e72e890810011200q101850a8v586a03c54a2c1f8b@mail.gmail.com> (sfid-20081001_210054_088211_C4394AE0)
Date: Wed, 1 Oct 2008 12:00:49 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Trigve <trigves@yahoo.com>
Subject: Re: intel wifi 5100 (iwlagn) authentication timed out
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20081001T185317-474@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <loom.20081001T181402-749@post.gmane.org>
	 <43e72e890810011142r62f8cbf2mfdb6bc2a0a2a7bbc@mail.gmail.com>
	 <loom.20081001T185317-474@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 1, 2008 at 11:57 AM, Trigve <trigves@yahoo.com> wrote:
> Luis R. Rodriguez <mcgrof@...> writes:
>> What kernel? Also, please see:
>>
>> http://wireless.kernel.org/en/users/Reporting_bugs
>>
>>   Luis
> Hi,
> Sorry was in hurry and forgot to add.
>
> I'm using OpenSuse 11.0 "uname -a":
> Linux dodes-nb 2.6.25.5-1.1-default #1 SMP 2008-06-07 01:55:22 +0200 x86_64
> x86_64 x86_64 GNU/Linux
>
> I'm using compat-wireless-old.tar.bz2 from date 1. oct 2008.

Please try to upgrade the kernel, compat-wireless-old hasn't had a lot
of love lately on 2.6.25.

  Luis

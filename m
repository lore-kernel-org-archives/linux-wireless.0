Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34378 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYJATS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 15:18:57 -0400
Received: by gxk9 with SMTP id 9so613522gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 12:18:56 -0700 (PDT)
Message-ID: <43e72e890810011218q501e773dx7544cc355c47438c@mail.gmail.com> (sfid-20081001_211900_395248_D6842EC3)
Date: Wed, 1 Oct 2008 12:18:56 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Trigve <trigves@yahoo.com>
Subject: Re: intel wifi 5100 (iwlagn) authentication timed out
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20081001T185846-857@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <loom.20081001T181402-749@post.gmane.org>
	 <43e72e890810011142r62f8cbf2mfdb6bc2a0a2a7bbc@mail.gmail.com>
	 <loom.20081001T185846-857@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 1, 2008 at 12:00 PM, Trigve <trigves@yahoo.com> wrote:
> Luis R. Rodriguez <mcgrof@...> writes:
>>
>> What kernel? Also, please see:
>>
>> http://wireless.kernel.org/en/users/Reporting_bugs
>>
>>   Luis
>
> Forgot to mention that I wasn't using NetworkManager and used only iwconfig,
> ifconfig and wpa_supplicant (if needed).

I hate to ask but are you sure Network Manager and wpa_supplicant were
not running? Did you check ps -ef ? Anyway, yes please upgrade your
kernel. Unless of course you wish to help move compat-wireless-old
move forward and help hack it to work.

  Luis

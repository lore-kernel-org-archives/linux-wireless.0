Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52353 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0FPPrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 11:47:09 -0400
Received: by pwi1 with SMTP id 1so3928707pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 08:47:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100616152903.GA3138@tuxdriver.com>
References: <AANLkTin9bG4qDEKwgOXmlR3k9wZ-JBSIlh3JzYjzVDeY@mail.gmail.com>
	<20100616.215523.1718341995174283889.kou@clear-code.com> <20100616134421.GB2404@tuxdriver.com>
	<20100617.000223.656204364469558896.kou@clear-code.com> <20100616152903.GA3138@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 16 Jun 2010 08:46:49 -0700
Message-ID: <AANLkTikkZQa37Y3DTMQlb1mzYE7qN9hqABvU2Tvwuobq@mail.gmail.com>
Subject: Re: [PATCH] zd1211rw: ignore unknown regulatory domain.
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kouhei Sutou <kou@clear-code.com>, Stephen.Chen@atheros.com,
	David.Quan@atheros.com, linux-wireless@vger.kernel.org,
	Michael.Green@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 8:29 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Jun 17, 2010 at 12:02:23AM +0900, Kouhei Sutou wrote:
>> Hi,
>>
>> In <20100616134421.GB2404@tuxdriver.com>
>>   "Re: [PATCH] zd1211rw: ignore unknown regulatory domain." on Wed, 16 Jun 2010 09:44:22 -0400,
>>   "John W. Linville" <linville@tuxdriver.com> wrote:
>>
>> > On Wed, Jun 16, 2010 at 09:55:23PM +0900, Kouhei Sutou wrote:
>> >
>> >> I used 'ZD_REGDOMAIN_JAPAN_GW_US54GXS' as a macro name for
>> >> 0x49 because 0x49 is used by GW-US54GXS. Is it OK? Or should
>> >> I use other name for it?
>> >
>> > Hopefully someone can suggest a better name.  Anyone know what inspired
>> > "ZD_REGDOMAIN_JAPAN_ADD"?
>>
>> 'ZD_REGDOMAIN_JAPAN_3' was used in another patch:
>>   https://patchwork.kernel.org/patch/47220/
>>
>> But I don't know why '3' was used...
>
> '3' makes sense to me.  The better question is why not change 'ADD' to '2'? :-)

2 is fine to replace ADD, I think "ADD" is additional :P

  Luis

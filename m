Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44587 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab0GPROc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 13:14:32 -0400
Received: by pvc7 with SMTP id 7so879158pvc.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jul 2010 10:14:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C403859.70201@openwrt.org>
References: <alpine.DEB.2.00.1007160440530.13924@lynx> <4C403859.70201@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 16 Jul 2010 10:14:06 -0700
Message-ID: <AANLkTinQPAyPD-27KFAhTzklVhV3zcDqizWbSj1Bdw0C@mail.gmail.com>
Subject: Re: what's the status of ATHEROS_AR71XX config variable?
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>, linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 16, 2010 at 3:45 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-07-16 10:43 AM, Robert P. J. Day wrote:
>>
>>   from drivers/net/wireless/ath/ath9k/Makefile:
>>
>> ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
>>
>> but there is no such config variable.  so i'm thinking *something*
>> should be removed.
> The platform port for AR71xx hasn't been submitted upstream yet. But the
> code in ahb.c is actively being used in OpenWrt.
>
> I don't know what the status on submitting the code to linux-mips is,
> but I've Cc'd Gabor, he should know ;)

If its actively being supporting and tested, why not submit it now?
Any particular large pending blockers?

  Luis

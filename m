Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49199 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1F2U0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 16:26:14 -0400
Received: by yia27 with SMTP id 27so620480yia.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 13:26:14 -0700 (PDT)
Message-ID: <4E0B8A61.8090600@upr.edu> (sfid-20110629_222617_907276_A6DE803A)
Date: Wed, 29 Jun 2011 16:26:09 -0400
From: Omar Abraham <omar.abraham@upr.edu>
MIME-Version: 1.0
To: Alex <alex9434@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Compile error in carl9170 on Debian Squeeze
References: <BANLkTimsGJo61eLp3NrVtDkh0m3CN3zDxw@mail.gmail.com>
In-Reply-To: <BANLkTimsGJo61eLp3NrVtDkh0m3CN3zDxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You are using older kernel headers, most likely that could be the problem

On 6/29/2011 4:18 PM, Alex wrote:
> I get the following error when I try to compile carl9170 on Debian
> Squeeze (armel)
>
> make[1]: Entering directory `/usr/src/linux-headers-2.6.32-5-kirkwood'
>    LD      /usr/src/compat-wireless-2011-06-29/compat/built-in.o
>    CC [M]  /usr/src/compat-wireless-2011-06-29/compat/main.o
> In file included from
> /usr/src/compat-wireless-2011-06-29/include/linux/compat-2.6.h:29,
>                   from<command-line>:0:
> /usr/src/compat-wireless-2011-06-29/include/linux/compat-2.6.34.h:23:
> error: redefinition of 'netdev_name'
> /usr/src/linux-headers-2.6.32-5-common/include/linux/netdevice.h:2032:
> error: previous definition of 'netdev_name' was here
> make[5]: *** [/usr/src/compat-wireless-2011-06-29/compat/main.o] Error 1
> make[4]: *** [/usr/src/compat-wireless-2011-06-29/compat] Error 2
> make[3]: *** [_module_/usr/src/compat-wireless-2011-06-29] Error 2
> make[2]: *** [sub-make] Error 2
> make[1]: *** [all] Error 2
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-5-kirkwood'
> make: *** [modules] Error 2
>
> Get the same error on older versions from 2010 of compat. Can anybody help me?
>
> Regards,
> alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


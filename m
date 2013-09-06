Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:38957 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3IFKVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 06:21:13 -0400
Received: by mail-ea0-f175.google.com with SMTP id m14so1485113eaj.20
        for <linux-wireless@vger.kernel.org>; Fri, 06 Sep 2013 03:21:12 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Brian O'Connor <bocon13@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: beginner build question
Date: Fri, 06 Sep 2013 12:21:07 +0200
Message-ID: <1781136.IRflOffuSs@blech> (sfid-20130906_122117_437499_A515032C)
In-Reply-To: <CAHhaCVjomgED0WW1fyUQbePNS0DnPEfKb5uE-+rEMhx6zgO1ZA@mail.gmail.com>
References: <CAHhaCVjomgED0WW1fyUQbePNS0DnPEfKb5uE-+rEMhx6zgO1ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Friday, September 06, 2013 02:27:26 AM Brian O'Connor wrote:
> I am trying to compile rtl8192su in Ubuntu 13.04 and I get the
> following error when I "make all":
> 
> make -C /lib/modules/3.10.10-031010-generic/build
> M=/home/media/rtl8192su/r92su CONFIG_R92SU=m CONFIG_R92SU_DEBUGFS=y
> CONFIG_R92SU_WPC=y all EXTRA_CFLAGS="-DDEBUG -DCONFIG_R92SU=m
                     ^^^
> -DCONFIG_R92SU_DEBUGFS=y -DCONFIG_R92SU_WPC=y"
> make[1]: Entering directory `/usr/src/linux-headers-3.10.10-031010-generic'
> make[1]: *** No rule to make target `vmlinux', needed by `all'.  Stop.
> make[1]: Leaving directory `/usr/src/linux-headers-3.10.10-031010-generic'
> make: *** [all] Error 2
> 
> Any suggestions?
Thanks for reporting this. I fixed the project's readme.
<https://github.com/chunkeey/rtl8192su/commit/d1934e155840ccd273a429d85f1f2aa407ba49b7>

Just run "make" instead of "make all".

Regards

Chr


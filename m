Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33009 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0IOQTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 12:19:06 -0400
Received: by iwn5 with SMTP id 5so249620iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 09:19:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikpijH_xp5cVzxJzc8udiDHcs_si56t373JGqFF@mail.gmail.com>
References: <AANLkTikpijH_xp5cVzxJzc8udiDHcs_si56t373JGqFF@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 15 Sep 2010 09:18:44 -0700
Message-ID: <AANLkTik4udFCkuHGJLjLx_XZVogUQcia8xm5R924_UOC@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_compat=2Dwireless_build_failure=3A_implicit_declarat?=
	=?UTF-8?Q?ion_of_function_=E2=80=98skb=5Fchecksum=5Fnone=5Fassert=E2=80=99?=
To: Darren Hart <darren@dvhart.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 8:58 AM, Darren Hart <darren@dvhart.com> wrote:
> I'm getting the follwoing errors trying to build
> compat-wireless-2010-09-12 on the following kernels:
> - 2.6.32-24-generic (Ubuntu 10.04)
> - 2.6.36-rc4
>
> $ ./scripts/driver-select intel
> $ make
> ...
>  CC [M]  /home/dvhart/work/source/linux/compat-wireless-2010-09-12/drivers/net/atl1c/atl1c_main.o
> /home/dvhart/work/source/linux/compat-wireless-2010-09-12/drivers/net/atl1c/atl1c_main.c:
> In function ‘atl1c_rx_checksum’:
> /home/dvhart/work/source/linux/compat-wireless-2010-09-12/drivers/net/atl1c/atl1c_main.c:1726:
> error: implicit declaration of function ‘skb_checksum_none_assert’
>
> It did this from a build a few days ago as well.

This should be fixed in recent compat-wireless releases, Haukes sent
me patches for it recently. I just merged them yesterday.

  Luis

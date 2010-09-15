Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50039 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0IOP6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 11:58:16 -0400
Received: by qwh6 with SMTP id 6so259853qwh.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 08:58:15 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Sep 2010 08:58:15 -0700
Message-ID: <AANLkTikpijH_xp5cVzxJzc8udiDHcs_si56t373JGqFF@mail.gmail.com>
Subject: =?windows-1252?Q?compat=2Dwireless_build_failure=3A_implicit_declaration_?=
	=?windows-1252?Q?of_function_=91skb=5Fchecksum=5Fnone=5Fassert=92?=
From: Darren Hart <darren@dvhart.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm getting the follwoing errors trying to build
compat-wireless-2010-09-12 on the following kernels:
- 2.6.32-24-generic (Ubuntu 10.04)
- 2.6.36-rc4

$ ./scripts/driver-select intel
$ make
...
  CC [M]  /home/dvhart/work/source/linux/compat-wireless-2010-09-12/drivers/net/atl1c/atl1c_main.o
/home/dvhart/work/source/linux/compat-wireless-2010-09-12/drivers/net/atl1c/atl1c_main.c:
In function ‘atl1c_rx_checksum’:
/home/dvhart/work/source/linux/compat-wireless-2010-09-12/drivers/net/atl1c/atl1c_main.c:1726:
error: implicit declaration of function ‘skb_checksum_none_assert’

It did this from a build a few days ago as well.

-- 
Darren Hart

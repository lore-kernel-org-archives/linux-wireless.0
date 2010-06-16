Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:60999 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0FPO4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 10:56:06 -0400
Received: by pxi8 with SMTP id 8so3916391pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 07:56:04 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Compat-wireless build on 2.6.34
Date: Wed, 16 Jun 2010 10:49:25 -0400
Message-ID: <87r5k76nii.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is the latest compat-wireless package known to build against 2.6.34? I
have tried both June 15 and June 14 and both fail with errors similar
to the following. Thanks for your help!

- Ben


make -C /lib/modules/2.6.34-ben/build
M=/home/ben/compat-wireless-2010-06-15 modules
make[1]: Entering directory `/home/ben/linux-stable'
  CC [M]
  /home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.o
  CC [M]
  /home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.o
  CC [M]
  /home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/libipw_module.o
  CC [M]
  /home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/libipw_tx.o
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:
In function ‘ipw2100_alloc_device’:
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:6138:
error: ‘struct net_device’ has no member named ‘wireless_handlers’
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:6144:
error: ‘struct net_device’ has no member named ‘wireless_data’
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:
At top level:
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8406:
error: unknown field ‘num_private’ specified in initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8406:
warning: initialization makes pointer from integer without a cast
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8407:
error: unknown field ‘num_private_args’ specified in initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8407:
warning: excess elements in struct initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8407:
warning: (near initialization for ‘ipw2100_wx_handler_def’)
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8408:
error: unknown field ‘private’ specified in initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8408:
warning: excess elements in struct initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8408:
warning: (near initialization for ‘ipw2100_wx_handler_def’)
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8409:
error: unknown field ‘private_args’ specified in initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8409:
warning: excess elements in struct initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2100.c:8409:
warning: (near initialization for ‘ipw2100_wx_handler_def’)
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10118:
error: unknown field ‘num_private’ specified in initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10118:
warning: initialization makes pointer from integer without a cast
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10119:
error: unknown field ‘num_private_args’ specified in initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10119:
warning: excess elements in struct initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10119:
warning: (near initialization for ‘ipw_wx_handler_def’)
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10120:
error: unknown field ‘private’ specified in initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10120:
warning: excess elements in struct initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10120:
warning: (near initialization for ‘ipw_wx_handler_def’)
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10121:
error: unknown field ‘private_args’ specified in initializer
/home/ben/compat-wireless-2010-06-15/drivers/net/wireless/ipw2x00/ipw2200.c:10121:
warning: excess elements in struct initializer
/home/ben/c

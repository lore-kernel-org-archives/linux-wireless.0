Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:40989 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab3BFPhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 10:37:37 -0500
Received: by mail-we0-f181.google.com with SMTP id t44so1214472wey.12
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 07:37:35 -0800 (PST)
Message-ID: <511278B7.8000600@gmail.com> (sfid-20130206_163740_342632_C4B6C1BC)
Date: Wed, 06 Feb 2013 16:37:27 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: stable compat-drivers-3.8-rc5-1 is broken
References: <510FAB9B.1040102@gmail.com>
In-Reply-To: <510FAB9B.1040102@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

with compat-drivers-3.8-rc5-1 I get:

make -C /lib/modules/3.7.5-101.fc17.x86_64/build M=/home/xose/tmp/compat-drivers-3.8-rc5-1 modules
make[1]: Entering directory `/usr/src/kernels/3.7.5-101.fc17.x86_64'
  CC [M]  /home/xose/tmp/compat-drivers-3.8-rc5-1/net/wireless/core.o
/home/xose/tmp/compat-drivers-3.8-rc5-1/net/wireless/core.c: In function ‘cfg80211_netdev_notifier_call’:
/home/xose/tmp/compat-drivers-3.8-rc5-1/net/wireless/core.c:895:3: error: implicit declaration of function ‘netdev_set_default_ethtool_ops’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

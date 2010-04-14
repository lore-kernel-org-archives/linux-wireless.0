Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:49620 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0DNVSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 17:18:13 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2403678fgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Apr 2010 14:18:12 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 15 Apr 2010 01:17:46 +0400
Message-ID: <g2kd01f95791004141417i66f279bbhc64274eb679fc6f5@mail.gmail.com>
Subject: compat wireless doesn't compile
From: Andrey Semyonov <gatekeeper.mail@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get this when trying to compile current drivers:


/usr/local/src/compat-wireless-2010-04-14# make
make -C /lib/modules/2.6.32-19-generic/build
M=/usr/local/src/compat-wireless-2010-04-14 modules
make[1]: Вход в каталог `/usr/src/linux-headers-2.6.32-19-generic'
  CC [M]  /usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.o
/usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.c: In
function 'ieee80211_alloc_hw':
/usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.c:394:
error: implicit declaration of function '__hw_addr_init'
make[3]: *** [/usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.o]
Ошибка 1
make[2]: *** [/usr/local/src/compat-wireless-2010-04-14/net/mac80211] Ошибка 2
make[1]: *** [_module_/usr/local/src/compat-wireless-2010-04-14] Ошибка 2
make[1]: Выход из каталога `/usr/src/linux-headers-2.6.32-19-generic'
make: *** [modules] Ошибка 2

The driver selected is b43. System is Ubuntu 10.04 beta2.

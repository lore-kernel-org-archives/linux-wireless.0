Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36424 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1K1MCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 07:02:51 -0500
Received: by ghrr1 with SMTP id r1so5098351ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 04:02:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMqtkVzpmAA0WsaUfGF5gQBHLjEjtU7PX6+TEwOsfAM=j4ok5g@mail.gmail.com>
References: <CAMqtkVzpmAA0WsaUfGF5gQBHLjEjtU7PX6+TEwOsfAM=j4ok5g@mail.gmail.com>
From: =?UTF-8?B?0JDQu9C10LrRgdCw0L3QtNGAINCn0LDQv9C60LjQvQ==?=
	<watashi@reisei.ru>
Date: Mon, 28 Nov 2011 16:02:30 +0400
Message-ID: <CAMqtkVzEBcAZ7XeScvLuKqLj1Sv-QQQqyVe5ZjnBtQeK6_SgYQ@mail.gmail.com> (sfid-20111128_130254_350391_15756BC0)
Subject: Fwd: Compilation error
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello! I have a compilation error while porting
compat-wireless-3.2-rc1-1 on 2.6.32 linux kernel


CC [M]  /home/username/compat-wireless-3.2-rc1-1/net/mac80211/main.o
In file included from
/home/username/compat-wireless-3.2-rc1-1/net/mac80211/ieee80211_i.h:30,
                 from
/home/username/compat-wireless-3.2-rc1-1/net/mac80211/main.c:27:
/home/username/compat-wireless-3.2-rc1-1/net/mac80211/key.h:88: error:
expected specifier-qualifier-list before 'atomic64_t'
/home/username/compat-wireless-3.2-rc1-1/net/mac80211/key.h:100:
error: expected specifier-qualifier-list before 'atomic64_t'
make[3]: *** [/home/username/compat-wireless-3.2-rc1-1/net/mac80211/main.o]
Ошибка 1
make[2]: *** [/home/username/compat-wireless-3.2-rc1-1/net/mac80211] Ошибка 2
make[1]: *** [_module_/home/username/compat-wireless-3.2-rc1-1] Ошибка 2
make[1]: Выход из каталога `/home/username/core-test-test/core_modified'
make: *** [modules] Ошибка 2

Please, help me to correct this.

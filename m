Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52718 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1HMPUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 11:20:20 -0400
Received: by yie30 with SMTP id 30so2548226yie.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 08:20:19 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 13 Aug 2011 17:20:18 +0200
Message-ID: <CACna6rwvjRm+yLyz-sbQjmot8ErhfLN5E0NgtW3kbgjPy+JwLA@mail.gmail.com> (sfid-20110813_172024_756818_3C00081A)
Subject: Hosting wl driver, part of GPL package
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I need some hosting for broadcom-wl-5.100.138.tar.bz2 extracted from
GPL sources.

Currently all the interesting drivers I've found are placed on:
http://broadcom.zajec.net/
but I can not guarantee 100% uptime or high bandwidth limit.

Can someone offer b43 a place to host that drivers? We need them to
extract firmware required for various Broadcom cards.

Up to now we were using openwrt's ftp but they don't host the newest
drivers. We need 5.100 or newer to have firmware for the newest cards
included (like HT-PHY).

-- 
Rafał

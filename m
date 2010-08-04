Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42940 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab0HDOSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 10:18:46 -0400
Received: by eya25 with SMTP id 25so1978184eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Aug 2010 07:18:45 -0700 (PDT)
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] build fixes for compat-wireless due to PCMCIA changes
Date: Wed,  4 Aug 2010 16:18:34 +0200
Message-Id: <1280931516-29665-1-git-send-email-kkhere.geo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
here are two patches for compat and compat-wireless that fix build with
linux-next.git tag next-20100804 and kernel v2.6.34

The patch for compat-wireless is only 
leftovers from Luis R. Rodriguez' commit dedb6981 in 
drivers/net/wireless/orinoco/{orinoco,spectrum}_cs.c

The patch for compat backports the newly added pcmcia_{read,write}_config_byte()
functions in <pcmcia/ds.h>

Thanks and regards.
--
Kshitij Kulshreshtha

Institut für Mathematik,
Universität Paderborn,
Warburger Straße 100,
33098 Paderborn.

Büro: A3.319

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35509 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbcEQWwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 18:52:41 -0400
Received: by mail-pf0-f196.google.com with SMTP id b66so3126787pfb.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 15:52:40 -0700 (PDT)
From: Dan Lenski <dlenski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Lenski <dlenski@gmail.com>, jes.sorensen@redhat.com
Subject: [PATCH] increase rtl8xxxu polling timeout for firmware startup
Date: Tue, 17 May 2016 15:48:14 -0700
Message-Id: <1463525295-10818-1-git-send-email-dlenski@gmail.com> (sfid-20160518_005245_102192_EED34E2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is the patch to increase the polling timeout for rtl8xxxu firmware
startup, and to make it configurable, as referred to in my previous message.

Dan Lenski (1):
  Make firmware startup polling timeout configurable, and increase
    default

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 +++++++----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.8.2


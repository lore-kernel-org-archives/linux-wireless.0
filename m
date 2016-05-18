Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35202 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbcERBPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 21:15:12 -0400
Received: by mail-pf0-f193.google.com with SMTP id b66so3395215pfb.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 18:15:12 -0700 (PDT)
From: Dan Lenski <dlenski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Lenski <dlenski@gmail.com>, jes.sorensen@redhat.com
Subject: [PATCH 0/2] rtl8xxxu: increase polling timeout for firmware startup
Date: Tue, 17 May 2016 18:14:44 -0700
Message-Id: <1463534086-22353-1-git-send-email-dlenski@gmail.com> (sfid-20160518_031521_971481_56C712DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are patches patch to increase the polling timeout for rtl8xxxu firmware
startup, and to make it configurable.

Resubmitting with changes per Julian Calaby's comments.


Dan Lenski (2):
  rtl8xxxu: Increase default polling timeout for firmware startup
  rtl8xxxu: Make polling timeout for firmware configurable

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 +++++++----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.8.2


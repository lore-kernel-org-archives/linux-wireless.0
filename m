Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36198 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbbLKBHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 20:07:45 -0500
Received: by lfed137 with SMTP id d137so17985795lfe.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2015 17:07:44 -0800 (PST)
From: Anatoly Stepanov <drivengroove@gmail.com>
To: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com
Cc: linux-wireless@vger.kernel.org,
	Anatoly Stepanov <drivengroove@gmail.com>
Subject: [PATCH 00/01] staging: wilc1000: fix sparse issue
Date: Thu, 10 Dec 2015 05:17:28 +0300
Message-Id: <1449713849-32245-1-git-send-email-drivengroove@gmail.com> (sfid-20151211_020748_790644_A4CF61BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings!

This patch fixes sparse static analyzer issue in wilc1000 driver.

Anatoly Stepanov (1):
  staging: wilc1000: add missing address space specifier

 drivers/staging/wilc1000/wilc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.1.0


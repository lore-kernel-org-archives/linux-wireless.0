Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36167 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbcERR5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 13:57:36 -0400
Received: by mail-pf0-f175.google.com with SMTP id c189so21414627pfb.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2016 10:57:35 -0700 (PDT)
From: Dan Lenski <dlenski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: jes.sorensen@redhat.com
Subject: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
Date: Wed, 18 May 2016 10:57:28 -0700
Message-Id: <1463594249-19524-1-git-send-email-dlenski@gmail.com> (sfid-20160518_195740_369738_0BC6BED3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is a patch to increase the polling timeout for rtl8xxxu firmware
startup.

This patch now applies cleanly to Jes Sorensen's rtl8xxxu-devel tree
(86c89dd4782030c4f9e0c82424a8b92f9fdb35aa).

The patch to make this a module parameter was removed.

Dan Lenski (1):
  rtl8xxxu: Increase default polling timeout for firmware startup

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.8.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:61295 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab1AGJmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 04:42:35 -0500
Received: by pxi15 with SMTP id 15so3040751pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 01:42:35 -0800 (PST)
Message-ID: <4D26E00B.2090202@gmail.com>
Date: Fri, 07 Jan 2011 17:42:35 +0800
From: stutiredboy <stutiredboy@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: brcm80211 can not set wireless interface mode master?
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

i recently change my wireless card driver to brcm80211

kernel: 2.6.37
wireless card: BCM43224 0x4353
unfortunately, i can not set my wireeless interface to work at 'master' mode

when i use iwconfig wlan0 mode master, infos as below:

Error for wireless request "Set Mode" (8B06) :
SET failed on device wlan0 ; Invalid argument.

the brcm80211 still do not support master mode or anything i missed ?

thanks very much
-- 
http://www.chenxiaosheng.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab0LSOmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Dec 2010 09:42:45 -0500
Received: from [192.168.178.92] (p5B319B26.dip0.t-ipconnect.de [91.49.155.38])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by v216570639.yourvserver.net (Postfix) with ESMTPSA id 84A29DFAA0E
	for <linux-wireless@vger.kernel.org>; Sun, 19 Dec 2010 15:42:43 +0100 (CET)
Message-ID: <4D0E19EB.3070802@lophus.org>
Date: Sun, 19 Dec 2010 15:42:51 +0100
From: "Jonas H." <jonas@lophus.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Recent suspend/resume fix for which devices?
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

My AR9285 wireless card, used with the ath9k driver, stops working after 
supsend/resume - I have to reboot to make it work again.

Trying to figure out whether this is fixed for 2.6.37 I noticed commit 
f933ebed (in Linus' tree) "ath9k_htc: Fix suspend/resume. 
The HW has to be set to FULLSLEEP mode during suspend, ...".

My question is: Does that fix also apply to my card? I realize the patch 
only applies to ath9k_htc but I couldn't figure what "htc" stands for in 
this context.

If it doesn't, does this mailing list also function as a bug tracker?

Thanks!
Jonas

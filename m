Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35009 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab0LTOyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 09:54:43 -0500
Received: by yxt3 with SMTP id 3so1328996yxt.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 06:54:42 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19727.28131.342814.867320@gargle.gargle.HOWL>
Date: Mon, 20 Dec 2010 20:23:23 +0530
To: "Jonas H." <jonas@lophus.org>
Cc: linux-wireless@vger.kernel.org
Subject: Recent suspend/resume fix for which devices?
In-Reply-To: <4D0E19EB.3070802@lophus.org>
References: <4D0E19EB.3070802@lophus.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonas H. wrote:
> Hello!
> 
> My AR9285 wireless card, used with the ath9k driver, stops working after 
> supsend/resume - I have to reboot to make it work again.
> 
> Trying to figure out whether this is fixed for 2.6.37 I noticed commit 
> f933ebed (in Linus' tree) "ath9k_htc: Fix suspend/resume. 
> The HW has to be set to FULLSLEEP mode during suspend, ...".
> 
> My question is: Does that fix also apply to my card? I realize the patch 
> only applies to ath9k_htc but I couldn't figure what "htc" stands for in 
> this context.

Nope, that commit is not relevant for ath9k, which is the driver for your card.
ath9k_htc is a different driver.

Sujith

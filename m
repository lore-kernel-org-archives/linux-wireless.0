Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout5.wanadoo.co.uk ([80.12.242.80]:45082 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3CHLZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 06:25:31 -0500
Date: Fri, 8 Mar 2013 12:25:29 +0100 (CET)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: linux-wireless@vger.kernel.org
Message-ID: <19954030.22961362741929700.JavaMail.www@wwinf3707> (sfid-20130308_122535_665924_2E5DC31D)
Subject: ath6kl build error.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I'm getting a build error when building ath6kl modules.

include/linux/mmc/sdio_func.h:162:12: error: expected identifier or '(' before numeric constant

the line it's complaining about is like this:

extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);


A bit of googling has shown that others have seen the same problem too.
But, I've not seen a fix for it.

Any ideas appreciated.


Regards

Nick Thomas

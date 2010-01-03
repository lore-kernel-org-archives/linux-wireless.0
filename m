Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:51007 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0ACNPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2010 08:15:12 -0500
Received: from cpe00142a336e11-cm001ac318e826.cpe.net.cable.rogers.com ([174.113.191.234] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1NRPaZ-0008PX-Dh
	for linux-wireless@vger.kernel.org; Sun, 03 Jan 2010 07:29:43 -0500
Date: Sun, 3 Jan 2010 07:28:46 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: what's with Kconfig variable ATHEROS_AR71XX?
Message-ID: <alpine.LFD.2.00.1001030727090.15360@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


$ grep -r ATHEROS_AR71XX *
drivers/net/wireless/ath/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
drivers/net/wireless/ath/ath9k/ath9k.h:#ifdef CONFIG_ATHEROS_AR71XX
$

  so there's no Kconfig variable by that name.  thoughts?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================

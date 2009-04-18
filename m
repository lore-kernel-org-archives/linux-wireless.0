Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:59471 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbZDROYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 10:24:34 -0400
Received: from [174.113.191.234] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1LvBT7-0002Ga-2e
	for linux-wireless@vger.kernel.org; Sat, 18 Apr 2009 10:24:33 -0400
Date: Sat, 18 Apr 2009 10:23:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: bad reference to atheros ar71xx config variable?
Message-ID: <alpine.LFD.2.00.0904181020490.25540@localhost.localdomain> (sfid-20090418_162436_362181_72D1EA2C)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


./drivers/net/wireless/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o

  there appears to be no such config variable.  is that a typo?

rday
--
========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================

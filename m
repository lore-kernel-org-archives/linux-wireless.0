Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:41901 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935955Ab0GPInt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 04:43:49 -0400
Date: Fri, 16 Jul 2010 04:43:37 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: what's the status of ATHEROS_AR71XX config variable?
Message-ID: <alpine.DEB.2.00.1007160440530.13924@lynx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


  from drivers/net/wireless/ath/ath9k/Makefile:

ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o

but there is no such config variable.  so i'm thinking *something*
should be removed.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41324 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab1GPQPS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 12:15:18 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qi7WD-00046K-W4
	for linux-wireless@vger.kernel.org; Sat, 16 Jul 2011 18:15:13 +0200
Received: from 221.131.175.226 ([221.131.175.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 18:15:05 +0200
Received: from wy52119514 by 221.131.175.226 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 18:15:05 +0200
To: linux-wireless@vger.kernel.org
From: wy408 <wy52119514@163.com>
Subject: compat-wireless cross compile
Date: Sat, 16 Jul 2011 15:54:13 +0000 (UTC)
Message-ID: <loom.20110716T174804-267@post.gmane.org> (sfid-20110716_181520_528938_720EF06F)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi，everyone：
i try to cross compile ath5k of compat-wireless for mips.
i use 
make
KLIB=/mnt/sda3/linux-kernel   
KLIB_BUILD=/mnt/sda3/linux-kernel

but errors:

config.mk:26:*****missing "endif"........

i used compat-wireless 2.6.38 39 37 ,and error again.

looking forward for your help.


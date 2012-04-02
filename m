Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:24334 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab2DBRuE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 13:50:04 -0400
Received: from out.poczta.wp.pl (HELO localhost) ([212.77.101.240])
          (envelope-sender <mikolaj.q@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-wireless@vger.kernel.org>; 2 Apr 2012 19:43:21 +0200
Date: Mon, 02 Apr 2012 19:43:21 +0200
From: =?ISO-8859-2?Q?Miko=B3aj_Kuligowski?= <mikolaj.q@wp.pl>
To: linux-wireless@vger.kernel.org
Subject: carl9170 driver - network connection breaks
Message-ID: <4f79e539d908b3.59415590@wp.pl> (sfid-20120402_195009_702089_B79F8D33)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

carl9170 driver - network connection "hangs". It happens if some bigger file is being downloaded (few MB or bigger). It doesn't happen on kernels less then 3.2 (works well with 3.1 and previous) and doesn't depend on firmware - it happens with all available firmware versions: 1.9.3, 1.9.4, 1.9.5.  I use USB wireless card TP-LINK TL-WN821N. Ubuntu 12.04. The device works perfect with Oneiric, breaks with Precise. Please help.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/971728

__________________



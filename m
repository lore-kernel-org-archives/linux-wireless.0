Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49708 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbYJXSh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:37:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: b43: Everybody with PHY TX error, please try
Date: Fri, 24 Oct 2008 20:32:04 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200810242032.04295.mb@bu3sch.de> (sfid-20081024_203730_616101_C9986446)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Everybody with PHY TX error, please try updated firmware from
ftp://ftp.linksys.com/opensourcecode/wrt610n/1.00.00.018/wrt610n_v1.00.00.018_us.tgz
(Yeah, big tarball. It's 87MB)

Extract the file wrt610n_v1.00.00.018_us/release/src/wl/linux/wl.o out of the archive.
Get latest b43-tools:
git clone http://git.bu3sch.de/git/b43-tools.git

Build and install fwcutter from latest b43-tools.git

Extract the firmware from the wl.o file:
b43-fwcutter --unsupported -w /lib/firmware/DESTPATH  wl.o

Try to reproduce the PHY TX error with the new firmware.

Thanks.

-- 
Greetings Michael.

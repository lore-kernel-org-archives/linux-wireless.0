Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38398
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbXHJXoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 19:44:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] Huge bcm43xx (b43) patchset
Date: Sat, 11 Aug 2007 01:01:21 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200708110101.22035.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's a HUGE bcm43xx patchset that updates/fixes
various things and renames bcm43xx to b43. It also
moves and renames all files.

The patch series is not attached to this mail, as it is
_really_ big.

The patches series can be downloaded here:
http://bu3sch.de/patches/wireless-dev/20070811-1186786487/patches/

A tarball containing all these patches is here:
http://bu3sch.de/patches/wireless-dev/20070811-1186786487/mb-wl-20070811-1186786487.tar.bz2

Please apply these patches to the b44 branch of wireless-dev.
(git has a quilt import, so that should be easy.)

Thanks.

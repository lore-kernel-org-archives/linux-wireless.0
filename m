Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:62671 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaEON4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 09:56:05 -0400
Date: Thu, 15 May 2014 10:56:00 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2014-05-15
Message-ID: <20140515135600.GB1966@joana> (sfid-20140515_155609_346453_98AF44DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This pull request contains a very important fix for 3.15. Here we fix the
permissions of a debugfs file that would otherwise allow unauthorized users
to write content to it.

Please pull! Thanks.

        Gustavo

---
The following changes since commit 1fb4e09a7e780b915dbd172592ae7e2a4c071065:

  Bluetooth: Add support for Lite-on [04ca:3007] (2014-04-25 09:47:16 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git master

for you to fetch changes up to 40b9397a1a61a37917b93e7d57e6f2faf3a086b4:

  Bluetooth: Fix L2CAP LE debugfs entries permissions (2014-05-14 09:07:07 -0700)

----------------------------------------------------------------
Samuel Ortiz (1):
      Bluetooth: Fix L2CAP LE debugfs entries permissions

 net/bluetooth/l2cap_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

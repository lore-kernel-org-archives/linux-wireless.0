Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:53579 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507Ab0BTWIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 17:08:10 -0500
From: florian@mickler.org
To: linux-wireless@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Florian Mickler <florian@mickler.org>
Subject: [PATCH 0/2] Document and enhance rfkill sysfs abi
Date: Sat, 20 Feb 2010 22:40:43 +0100
Message-Id: <1266702045-6062-1-git-send-email-florian@mickler.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

The first patch shuffles the sysfs-rfkill abi documentation into
Documentation/ABI. The second patch is more a "why not?" question in
patch-form. After stumbling over this arbitrary limitation of the rfkill*/state
in the Documentation.

Well.. why not?

Cheers,
Flo

Florian Mickler (2):
  Document the rfkill sysfs ABI
  enhance /sys/class/rfkill/<rfkill>/state interface

 Documentation/ABI/stable/sysfs-class-rfkill |   65 +++++++++++++++++++++++++++
 Documentation/rfkill.txt                    |   44 +++++-------------
 include/linux/rfkill.h                      |    3 +
 net/rfkill/core.c                           |    9 +++-
 4 files changed, 89 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-rfkill


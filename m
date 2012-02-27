Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42124 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab2B0Vja (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 16:39:30 -0500
Subject: wireless-testing fail compiling
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 12:28:19 -0800
Message-ID: <1330374499.12612.18.camel@wwguy-huron> (sfid-20120227_223933_355430_DCAFB9E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

build break in the latest wireless-testing

fs/autofs4/inode.c: In function ‘autofs4_fill_super’:
fs/autofs4/inode.c:228: error: implicit declaration of function
‘is_compat_task’
make[2]: *** [fs/autofs4/inode.o] Error 1
make[1]: *** [fs/autofs4] Error 2
make: *** [fs] Error 2


fs/autofs4/dev-ioctl.c: In function ‘autofs_dev_ioctl_setpipefd’:
fs/autofs4/dev-ioctl.c:388: error: implicit declaration of function
‘is_compat_task’
make[2]: *** [fs/autofs4/dev-ioctl.o] Error 1



Wey



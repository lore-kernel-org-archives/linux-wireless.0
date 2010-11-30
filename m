Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:9070
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525Ab0K3SmD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 13:42:03 -0500
Received: from mail70-am1 (localhost.localdomain [127.0.0.1])	by
 mail70-am1-R.bigfish.com (Postfix) with ESMTP id 77F7D14584C1	for
 <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 18:26:56 +0000 (UTC)
Received: from AM1EHSMHS011.bigfish.com (unknown [10.3.201.247])	by
 mail70-am1.bigfish.com (Postfix) with ESMTP id 05D421120050	for
 <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 18:26:56 +0000 (UTC)
From: "Heyendal, Carl" <CHeyendal@stanleyworks.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 30 Nov 2010 13:26:13 -0500
Subject: build error with iw-0.9.21
Message-ID: <1D6034426110564DA0DEA9EE9793B38357E35E4103@NBE-MBX01.americas.swk.pri>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
I'm getting a linker error when I compile the latest 'iw-0.9.21' package with 'libnl-2.0'.

Note: I'm cross compiling for an ARM platform using CodeSourcery tools.

Any help appreciated.

thanx
/carl

---------------------------------------------------------------------------------------------
heyendal@ubuntu1-carlh:~/projects/AM1808/wireless/iw-0.9.21$ make CC=arm-none-linux-gnueabi-gcc
 CC   iw.o
 CC   genl.o
 CC   event.o
 CC   info.o
 CC   phy.o
 CC   interface.o
 CC   ibss.o
 CC   station.o
 CC   survey.o
 CC   util.o
 CC   mesh.o
 CC   mpath.o
 CC   scan.o
 CC   reg.o
 GEN  version.c
 CC   version.o
 CC   reason.o
 CC   status.o
 CC   connect.o
 CC   link.o
 CC   offch.o
 CC   ps.o
 CC   cqm.o
 CC   bitrate.o
 CC   sections.o
 CC   iw
/home/heyendal/projects/AM1808/platform/sdk_1_10_00_00/fs/sd_fs_working/lib/libnl.a(utils.o): In function `nl_prob2int':
/home/heyendal/projects/AM1808/wireless/libnl-2.0/lib/utils.c:257: undefined reference to `lrint'
collect2: ld returned 1 exit status
make: *** [iw] Error 1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:53170 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbXILVEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 17:04:24 -0400
Received: by ug-out-1314.google.com with SMTP id z38so303649ugc
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2007 14:04:22 -0700 (PDT)
Message-ID: <46E8557F.2080401@gmail.com>
Date: Wed, 12 Sep 2007 22:09:19 +0100
MIME-Version: 1.0
To: orinoco-devel@lists.sourceforge.net,
	orinoco-users@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, proski@gnu.org,
	hermes@gibson.dropbear.id.au
Subject: [PATCH 00/05] orinoco: Agere/Lucent firmware download
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implements firmware download to RAM for Lucent-Agere firmware.
Firmware download is a requirement to implement WPA on these cards.

The patchset is against v2.6.23-rc5 from Linus' git tree. The complete
patch is available at <http://www.virtualsoup.org/files/orinoco_fw_dl.patch>

Programs to generate the necessary firmware are available at
<http://www.virtualsoup.org/files/orinoco_dump_fw.tar.bz2>. They
require either the wl_lkm_714/8 sources or a windows driver. See
README.dump_fw for more information.

The following firmwares download and run on my Dell TrueMobile 1150:
7.65, 8.10, 8.42, 8.58

The following firmwares download, but are not compatible with the
current orinoco_cs driver:
9.40, 9.42, 9.48

All my testing done on a pentium3 Dell C600. FW 9.48 download also
confirmed on a powerbook using a modified airport driver compiled
with a static copy of the firmware

An earlier version of this patch was posted to the orinoco-devel
list. This version has been cleaned up and updated for big endian
architectures.


Regards,

Dave Kilroy.


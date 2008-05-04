Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from et1.ou.edu ([129.15.0.239]:60504 "EHLO
	it-rosebowl.sooner.net.ou.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756038AbYEDOg2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 10:36:28 -0400
From: "Williams, Jeffrey D." <angelbane@ou.edu>
To: Cheney Tang <seerfar@gmail.com>
CC: YanBo <dreamfly281@gmail.com>,
	Wessam Baghdadi <wbaghdadi@gmail.com>,
	"prjmgr@linuxdriverproject.org" <prjmgr@linuxdriverproject.org>,
	wireless <linux-wireless@vger.kernel.org>
Date: Sun, 4 May 2008 09:32:53 -0500
Subject: RE: airgo wireless drivers
Message-ID: <A60A684EB5844943950A980569765A0C014C3099837D@XMAIL2.sooner.net.ou.edu> (sfid-20080504_163554_878926_EDC0D2AD)
References: <13ed5f4a0804250050k2384ed22m3df9dd7bd18974c4@mail.gmail.com>
 <3cc280290804262233o1b44dd33if4a9802d19506761@mail.gmail.com>
 <1197ff4c0804262359r4fa5f94em350c987278c417fe@mail.gmail.com>
 <A60A684EB5844943950A980569765A0C014C30998345@XMAIL2.sooner.net.ou.edu>,<3cc280290805040727o4d8711c5nfec7f90676830071@mail.gmail.com>
In-Reply-To: <3cc280290805040727o4d8711c5nfec7f90676830071@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> I had got the cross compiled toolchain from Yanbo. Does crossdev work on Fedora?
> Is the MIPS hardware required? I have only X86 hardware.
> I had achieve greatly on reversing the driver on Windows, though there
> is no good tool to disassemble it fully yet. I think I can overcome
> it. The driver on Windows is for F5D8010 chipset. Some of its action
> are identical with the driver on MIPS, otheres not so.
> I guess they are not for same chipset and they are the same family chipset.

No, MIPS hardware isn't required, I did all of the reverse engineering on X86 machines. And from what I can tell, all of the drivers for airgo chipsets, whether on linux-based routers or windows are generated from the more or less the same sources. In fact, the AGN300 drivers use most of the original code written for the agn100.

Jeff

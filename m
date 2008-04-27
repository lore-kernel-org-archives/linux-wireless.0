Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from et1.ou.edu ([129.15.0.239]:22392 "EHLO
	it-rosebowl.sooner.net.ou.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752530AbYD0QaS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 12:30:18 -0400
From: "Williams, Jeffrey D." <angelbane@ou.edu>
To: YanBo <dreamfly281@gmail.com>, Cheney Tang <seerfar@gmail.com>
CC: Wessam Baghdadi <wbaghdadi@gmail.com>,
	"prjmgr@linuxdriverproject.org" <prjmgr@linuxdriverproject.org>,
	wireless <linux-wireless@vger.kernel.org>
Date: Sun, 27 Apr 2008 11:22:13 -0500
Subject: RE: airgo wireless drivers
Message-ID: <A60A684EB5844943950A980569765A0C014C30998345@XMAIL2.sooner.net.ou.edu> (sfid-20080427_183030_854741_3A24F8D5)
References: <13ed5f4a0804250050k2384ed22m3df9dd7bd18974c4@mail.gmail.com>
 <3cc280290804262233o1b44dd33if4a9802d19506761@mail.gmail.com>,<1197ff4c0804262359r4fa5f94em350c987278c417fe@mail.gmail.com>
In-Reply-To: <1197ff4c0804262359r4fa5f94em350c987278c417fe@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



________________________________________
From: YanBo [dreamfly281@gmail.com]
Sent: Sunday, April 27, 2008 1:59 AM
To: Cheney Tang
Cc: Wessam Baghdadi; prjmgr@linuxdriverproject.org; Williams, Jeffrey D.; wireless
Subject: Re: airgo wireless drivers

On Sun, Apr 27, 2008 at 1:33 PM, Cheney Tang <seerfar@gmail.com> wrote:
> On Fri, Apr 25, 2008 at 3:50 PM, Wessam Baghdadi <wbaghdadi@gmail.com> wrote:
>  > hi,
>  >
>  >  I've been looking into the out of tree driver for Airgo MIMO wireless
>  >  - the current status is detaied in a post on the linux wireless
>  >  mailing list http://article.gmane.org/gmane.linux.kernel.wireless.general/13784
>  I am reversing engineer the airgo driver on Windows. There are some
>  difficulty, especially
>  no one disasseembly tool can deal with it fully. IDA can disassemble
>  only some parts and others is not available. I try another method to
>  reverse it. From the current partial result obtained, it is very
>  different between Window driver and Jeff'
>  Specifications(http://airgo.wdwconsulting.net/mymoin).
>
>  >
>  >  Airgo is now part of Qualcomm, but surprisingly enough there is a
>  >  claim that one of the airgo engineers had developed linux drivers that
>  >  were held back.
>  Yanbo had download a Airgo driver from internet and share it with me.
>  The driver is for MIPS on Linux 2.4. It composes two files: one is a simple
>  module and another is low level driver. IDA can disassemble the former
>  and do the
>  latter partly. I had try some objdump for MIPS to disassemble it, all failed.
>  I guess the driver is for specific chipset.
>  >

I've already got a lot of it reverse engineered. I'd share the sources with you that I do have, but they will be inaccessable to me for at least 4-6 weeks. All I can offer you is to get in touch with Felix Fietkau (nbd) of the openwrt project, he has some source code for the agn300 that you can look at. You'll also need a cross-compiled toolchain for the mips chipset, not the standard objdump. Use crossdev for gentoo, or ubuntu has them in its repos.

Jeff

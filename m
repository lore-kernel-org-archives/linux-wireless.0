Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:18119 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYEDO1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 10:27:21 -0400
Received: by rv-out-0506.google.com with SMTP id l9so742973rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 May 2008 07:27:21 -0700 (PDT)
Message-ID: <3cc280290805040727o4d8711c5nfec7f90676830071@mail.gmail.com> (sfid-20080504_162647_066387_FD11737D)
Date: Sun, 4 May 2008 22:27:18 +0800
From: "Cheney Tang" <seerfar@gmail.com>
To: "Williams, Jeffrey D." <angelbane@ou.edu>
Subject: Re: airgo wireless drivers
Cc: YanBo <dreamfly281@gmail.com>,
	"Wessam Baghdadi" <wbaghdadi@gmail.com>,
	"prjmgr@linuxdriverproject.org" <prjmgr@linuxdriverproject.org>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <A60A684EB5844943950A980569765A0C014C30998345@XMAIL2.sooner.net.ou.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <13ed5f4a0804250050k2384ed22m3df9dd7bd18974c4@mail.gmail.com>
	 <3cc280290804262233o1b44dd33if4a9802d19506761@mail.gmail.com>
	 <1197ff4c0804262359r4fa5f94em350c987278c417fe@mail.gmail.com>
	 <A60A684EB5844943950A980569765A0C014C30998345@XMAIL2.sooner.net.ou.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 28, 2008 at 12:22 AM, Williams, Jeffrey D. <angelbane@ou.edu> wrote:
>
>
>  ________________________________________
>  From: YanBo [dreamfly281@gmail.com]
>  Sent: Sunday, April 27, 2008 1:59 AM
>  To: Cheney Tang
>  Cc: Wessam Baghdadi; prjmgr@linuxdriverproject.org; Williams, Jeffrey D.; wireless
>  Subject: Re: airgo wireless drivers
>
>
>  On Sun, Apr 27, 2008 at 1:33 PM, Cheney Tang <seerfar@gmail.com> wrote:
>  > On Fri, Apr 25, 2008 at 3:50 PM, Wessam Baghdadi <wbaghdadi@gmail.com> wrote:
>  >  > hi,
>  >  >
>  >  >  I've been looking into the out of tree driver for Airgo MIMO wireless
>  >  >  - the current status is detaied in a post on the linux wireless
>  >  >  mailing list http://article.gmane.org/gmane.linux.kernel.wireless.general/13784
>  >  I am reversing engineer the airgo driver on Windows. There are some
>  >  difficulty, especially
>  >  no one disasseembly tool can deal with it fully. IDA can disassemble
>  >  only some parts and others is not available. I try another method to
>  >  reverse it. From the current partial result obtained, it is very
>  >  different between Window driver and Jeff'
>  >  Specifications(http://airgo.wdwconsulting.net/mymoin).
>  >
>  >  >
>  >  >  Airgo is now part of Qualcomm, but surprisingly enough there is a
>  >  >  claim that one of the airgo engineers had developed linux drivers that
>  >  >  were held back.
>  >  Yanbo had download a Airgo driver from internet and share it with me.
>  >  The driver is for MIPS on Linux 2.4. It composes two files: one is a simple
>  >  module and another is low level driver. IDA can disassemble the former
>  >  and do the
>  >  latter partly. I had try some objdump for MIPS to disassemble it, all failed.
>  >  I guess the driver is for specific chipset.
>  >  >
>
>  I've already got a lot of it reverse engineered. I'd share the sources with you that I do have, but they will be inaccessable to me for at least 4-6 weeks. All I can offer you is to get in touch with Felix Fietkau (nbd) of the openwrt project, he has some source code for the agn300 that you can look at. You'll also need a cross-compiled toolchain for the mips chipset, not the standard objdump. Use crossdev for gentoo, or ubuntu has them in its repos.

I had got the cross compiled toolchain from Yanbo. Does crossdev work on Fedora?
Is the MIPS hardware required? I have only X86 hardware.
I had achieve greatly on reversing the driver on Windows, though there
is no good tool to disassemble it fully yet. I think I can overcome
it. The driver on Windows is for F5D8010 chipset. Some of its action
are identical with the driver on MIPS, otheres not so.
I guess they are not for same chipset and they are the same family chipset.
>
>  Jeff
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:57729 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYD0G7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 02:59:31 -0400
Received: by wf-out-1314.google.com with SMTP id 28so3511940wff.4
        for <linux-wireless@vger.kernel.org>; Sat, 26 Apr 2008 23:59:31 -0700 (PDT)
Message-ID: <1197ff4c0804262359r4fa5f94em350c987278c417fe@mail.gmail.com> (sfid-20080427_085946_309830_531F1653)
Date: Sun, 27 Apr 2008 14:59:29 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Cheney Tang" <seerfar@gmail.com>
Subject: Re: airgo wireless drivers
Cc: "Wessam Baghdadi" <wbaghdadi@gmail.com>,
	prjmgr@linuxdriverproject.org,
	"Williams, Jeffrey D." <angelbane@ou.edu>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <3cc280290804262233o1b44dd33if4a9802d19506761@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <13ed5f4a0804250050k2384ed22m3df9dd7bd18974c4@mail.gmail.com>
	 <3cc280290804262233o1b44dd33if4a9802d19506761@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

You can download the whole toolchains from the link
http://www.linksys.com/servlet/Satellite?childpagename=US%2FLayout&packedargs=c%3DL_Content_C1%26cid%3D1115416836002&pagename=Linksys%2FCommon%2FVisitorWrapper
IIRIC the type should be WRT54GX

Yanbo




>(http://www.linuxelectrons.com/news/mobile/airgo-and-asus-team-launch-faster-wired-laptop).
>  >
>  >  He still works at Qualcomm and has a linkedin profile here
>  >  (http://www.linkedin.com/in/cfliu)
>  >
>  >  Is it possible that someone could get in touch with him (or Qualcomm) to see:
>  >
>  >  * if these mythical drivers were indeed developed, the status of the
>  >  drivers and the possibility of Qualcomm releasing the source?
>  >
>  >  * the possibility of releasing the complete specifications of the chipset?
>  >
>  >  thanks,
>  >
>  >  wessam
>  >  _______________________________________________
>  >  prjmgr mailing list
>  >  prjmgr@linuxdriverproject.org
>  >  http://driverdev.linuxdriverproject.org/mailman/listinfo/prjmgr
>  >
>

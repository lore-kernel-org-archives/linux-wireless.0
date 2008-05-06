Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:49039 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYEFDSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 23:18:55 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1461299rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 20:18:54 -0700 (PDT)
Message-ID: <3cc280290805052018l7455bec6y70bda2716bbb902f@mail.gmail.com> (sfid-20080506_051818_476909_06C88C01)
Date: Tue, 6 May 2008 11:18:54 +0800
From: "Cheney Tang" <seerfar@gmail.com>
To: "Williams, Jeffrey D." <angelbane@ou.edu>
Subject: Re: airgo wireless drivers
Cc: YanBo <dreamfly281@gmail.com>,
	"Wessam Baghdadi" <wbaghdadi@gmail.com>,
	"prjmgr@linuxdriverproject.org" <prjmgr@linuxdriverproject.org>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <A60A684EB5844943950A980569765A0C014C3099837D@XMAIL2.sooner.net.ou.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <13ed5f4a0804250050k2384ed22m3df9dd7bd18974c4@mail.gmail.com>
	 <3cc280290804262233o1b44dd33if4a9802d19506761@mail.gmail.com>
	 <1197ff4c0804262359r4fa5f94em350c987278c417fe@mail.gmail.com>
	 <A60A684EB5844943950A980569765A0C014C30998345@XMAIL2.sooner.net.ou.edu>
	 <3cc280290805040727o4d8711c5nfec7f90676830071@mail.gmail.com>
	 <A60A684EB5844943950A980569765A0C014C3099837D@XMAIL2.sooner.net.ou.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 4, 2008 at 10:32 PM, Williams, Jeffrey D. <angelbane@ou.edu> wrote:
>
>
>  > I had got the cross compiled toolchain from Yanbo. Does crossdev work on Fedora?
>  > Is the MIPS hardware required? I have only X86 hardware.
>  > I had achieve greatly on reversing the driver on Windows, though there
>  > is no good tool to disassemble it fully yet. I think I can overcome
>  > it. The driver on Windows is for F5D8010 chipset. Some of its action
>  > are identical with the driver on MIPS, otheres not so.
>  > I guess they are not for same chipset and they are the same family chipset.
>
>  No, MIPS hardware isn't required, I did all of the reverse engineering on X86 machines. And from what I can tell, all of the drivers for airgo chipsets, whether on linux-based routers or windows are generated from the more or less the same sources. In fact, the AGN300 drivers use most of the original code written for the agn100.
Did any one run the driver? Or is it possible to run it on x86 hardware?
>
>  Jeff
>

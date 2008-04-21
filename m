Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:23799 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbYDUCRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 22:17:55 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1197960wff.4
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2008 19:17:55 -0700 (PDT)
Message-ID: <1197ff4c0804201917m53eb2f84pd1b426326c98718f@mail.gmail.com> (sfid-20080421_031809_784379_5F78F9B3)
Date: Mon, 21 Apr 2008 10:17:54 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Wessam Baghdadi" <wbaghdadi@gmail.com>
Subject: Re: Airgo MIMO wireless card Linux drive
Cc: wireless <linux-wireless@vger.kernel.org>,
	agnx80211driver-devel@lists.sourceforge.net
In-Reply-To: <13ed5f4a0804180330u3fa526dsd5d341f2f4a147d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <13ed5f4a0804180330u3fa526dsd5d341f2f4a147d4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 18, 2008 at 6:30 PM, Wessam Baghdadi <wbaghdadi@gmail.com> wrote:
> Hi,
>
>  I just came across your driver - yet to test it (using ndiswrapper +
>  Linksys WMP54GX), but thanks in advance.
>
>  A couple of questions for you:
>
>  What is the current status of the driver? Is it working for both
>  AGN100 and AGN300?
>

Just for AGN100 at this monment, but not very stable, specify speak,
it will lost the associate after a while and the highest TX speed
just reached to 8Mbit/S.

>  Looking at the git tree here
>  http://git.sipsolutions.net/?p=agnx.git;a=summary I can't see any new
>  commits since January.

Yes, It is my fault, I am very busy for another company's project
recently. hence have not too much time to maintain and update the
code, but I want to spend more time on it when I have time in later.

>
>  Has this driver been incorporated into the current kernel wireless stack?
>

Not yet.

>  Is all the documentation here http://airgo.wdwconsulting.net/mymoin
>  complete? What is missing?
>

Yes, all reverse engineer chipset info are local in this Website. it
was maintained by Jeff, but he has quit this project for something he
has to do. as you know, this driver is totally based on reverse
engineer, and lot of hardware detail hasn't been figure out yet, so
this is the biggest
balk for this project. If any volunteer like to burden this task, it
will be greatly welcome.

>  I'm interested in contacted the Linux Driver Project
>  http://www.linuxdriverproject.org/twiki/bin/view to see if they will
>  continue the development/maintenance of the driver and incorporate it
>  in the wireless stack.
>

It is also greatly welcome. Thanks.

BR
Li Yanbo

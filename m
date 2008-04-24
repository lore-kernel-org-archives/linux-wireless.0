Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:41847 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYDXQXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 12:23:25 -0400
Received: by yw-out-2324.google.com with SMTP id 5so342309ywh.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2008 09:23:10 -0700 (PDT)
Message-ID: <13ed5f4a0804240923p13dcb7c4qa643297926eeeea2@mail.gmail.com> (sfid-20080424_182357_555564_3A2F211E)
Date: Fri, 25 Apr 2008 02:23:07 +1000
From: "Wessam Baghdadi" <wbaghdadi@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>,
	agnx80211driver-devel@lists.sourceforge.net
Subject: Re: Airgo MIMO wireless card Linux drive
Cc: dreamfly281@gmail.com
In-Reply-To: <1197ff4c0804201917m53eb2f84pd1b426326c98718f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <13ed5f4a0804180330u3fa526dsd5d341f2f4a147d4@mail.gmail.com>
	 <1197ff4c0804201917m53eb2f84pd1b426326c98718f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/4/21 YanBo <dreamfly281@gmail.com>:
> On Fri, Apr 18, 2008 at 6:30 PM, Wessam Baghdadi <wbaghdadi@gmail.com> wrote:
>  > Hi,
>  >
>  >  I just came across your driver - yet to test it (using ndiswrapper +
>  >  Linksys WMP54GX), but thanks in advance.
>  >
>  >  A couple of questions for you:
>  >
>  >  What is the current status of the driver? Is it working for both
>  >  AGN100 and AGN300?
>  >
>
>  Just for AGN100 at this monment, but not very stable, specify speak,
>  it will lost the associate after a while and the highest TX speed
>  just reached to 8Mbit/S.
>
>
>  >  Looking at the git tree here
>  >  http://git.sipsolutions.net/?p=agnx.git;a=summary I can't see any new
>  >  commits since January.
>
>  Yes, It is my fault, I am very busy for another company's project
>  recently. hence have not too much time to maintain and update the
>  code, but I want to spend more time on it when I have time in later.
>
>
>  >
>  >  Has this driver been incorporated into the current kernel wireless stack?
>  >
>
>  Not yet.
>
>
>  >  Is all the documentation here http://airgo.wdwconsulting.net/mymoin
>  >  complete? What is missing?
>  >
>
>  Yes, all reverse engineer chipset info are local in this Website. it
>  was maintained by Jeff, but he has quit this project for something he
>  has to do. as you know, this driver is totally based on reverse
>  engineer, and lot of hardware detail hasn't been figure out yet, so
>  this is the biggest
>  balk for this project. If any volunteer like to burden this task, it
>  will be greatly welcome.
>
>
>  >  I'm interested in contacted the Linux Driver Project
>  >  http://www.linuxdriverproject.org/twiki/bin/view to see if they will
>  >  continue the development/maintenance of the driver and incorporate it
>  >  in the wireless stack.
>  >
>
>  It is also greatly welcome. Thanks.
>
>  BR
>  Li Yanbo
>

I understand that Airgo released some GPL code a while back
(http://web.archive.org/web/20051219012536/http://gpl.airgonetworks.com/)
and Belkin released the GPL source & toolchain to their F5D9630
(Wireless G+ MIMO Modem Router) recently - I have no idea if this code
includes source related to the chipset or if Jeff looked at this
source when reverse eng the specs.

Airgo is now part of Qualcomm, but surprisingly enough there is a
claim that one of the airgo engineers had developed linux drivers that
were held back.
(http://www.linuxelectrons.com/news/mobile/airgo-and-asus-team-launch-faster-wired-laptop).
He still works at Qualcomm and has a linkedin profile here
(http://www.linkedin.com/in/cfliu)

Is it possible that one of the maintainers could get in touch with him to see:

* if these mythical drivers were indeed developed, the status of the
drivers and the possibility of Qualcomm releasing the source?

* the possibility of releasing the complete specifications of the chipset?

If no one here is the right person to get in touch with David, perhaps
someone can point me in the right direction?

thanks,

wessam

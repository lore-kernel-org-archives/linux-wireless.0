Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:40179 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbYDZCAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2008 22:00:17 -0400
Received: by wf-out-1314.google.com with SMTP id 28so3124001wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 19:00:16 -0700 (PDT)
Message-ID: <1197ff4c0804251900u1a4f4c4y7bf53b51d9945e61@mail.gmail.com> (sfid-20080426_040041_753283_49A0C5EF)
Date: Sat, 26 Apr 2008 10:00:13 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Wessam Baghdadi" <wbaghdadi@gmail.com>
Subject: Re: Airgo MIMO wireless card Linux drive
Cc: wireless <linux-wireless@vger.kernel.org>,
	agnx80211driver-devel@lists.sourceforge.net
In-Reply-To: <13ed5f4a0804240923p13dcb7c4qa643297926eeeea2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <13ed5f4a0804180330u3fa526dsd5d341f2f4a147d4@mail.gmail.com>
	 <1197ff4c0804201917m53eb2f84pd1b426326c98718f@mail.gmail.com>
	 <13ed5f4a0804240923p13dcb7c4qa643297926eeeea2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 25, 2008 at 12:23 AM, Wessam Baghdadi <wbaghdadi@gmail.com> wrote:
> 2008/4/21 YanBo <dreamfly281@gmail.com>:
>
>
> > On Fri, Apr 18, 2008 at 6:30 PM, Wessam Baghdadi <wbaghdadi@gmail.com> wrote:
>  >  > Hi,
>  >  >
>  >  >  I just came across your driver - yet to test it (using ndiswrapper +
>  >  >  Linksys WMP54GX), but thanks in advance.
>  >  >
>  >  >  A couple of questions for you:
>  >  >
>  >  >  What is the current status of the driver? Is it working for both
>  >  >  AGN100 and AGN300?
>  >  >
>  >
>  >  Just for AGN100 at this monment, but not very stable, specify speak,
>  >  it will lost the associate after a while and the highest TX speed
>  >  just reached to 8Mbit/S.
>  >
>  >
>  >  >  Looking at the git tree here
>  >  >  http://git.sipsolutions.net/?p=agnx.git;a=summary I can't see any new
>  >  >  commits since January.
>  >
>  >  Yes, It is my fault, I am very busy for another company's project
>  >  recently. hence have not too much time to maintain and update the
>  >  code, but I want to spend more time on it when I have time in later.
>  >
>  >
>  >  >
>  >  >  Has this driver been incorporated into the current kernel wireless stack?
>  >  >
>  >
>  >  Not yet.
>  >
>  >
>  >  >  Is all the documentation here http://airgo.wdwconsulting.net/mymoin
>  >  >  complete? What is missing?
>  >  >
>  >
>  >  Yes, all reverse engineer chipset info are local in this Website. it
>  >  was maintained by Jeff, but he has quit this project for something he
>  >  has to do. as you know, this driver is totally based on reverse
>  >  engineer, and lot of hardware detail hasn't been figure out yet, so
>  >  this is the biggest
>  >  balk for this project. If any volunteer like to burden this task, it
>  >  will be greatly welcome.
>  >
>  >
>  >  >  I'm interested in contacted the Linux Driver Project
>  >  >  http://www.linuxdriverproject.org/twiki/bin/view to see if they will
>  >  >  continue the development/maintenance of the driver and incorporate it
>  >  >  in the wireless stack.
>  >  >
>  >
>  >  It is also greatly welcome. Thanks.
>  >
>  >  BR
>  >  Li Yanbo
>  >
>
>  I understand that Airgo released some GPL code a while back
>  (http://web.archive.org/web/20051219012536/http://gpl.airgonetworks.com/)
>  and Belkin released the GPL source & toolchain to their F5D9630

Not sure F5D9630 contain the Airgo chipset, FWIK F5d8010 contain the
agn100 chipset

>  (Wireless G+ MIMO Modem Router) recently - I have no idea if this code
>  includes source related to the chipset or if Jeff looked at this
>  source when reverse eng the specs.
>

The Linksys published the source code for WRT54GX in its website, and
it contains the binary driver for  Agn100.  I guess Jeff also has some
binary code of Agn300, but don't know specify.


>  Airgo is now part of Qualcomm, but surprisingly enough there is a
>  claim that one of the airgo engineers had developed linux drivers that
>  were held back.
>  (http://www.linuxelectrons.com/news/mobile/airgo-and-asus-team-launch-faster-wired-laptop).
>  He still works at Qualcomm and has a linkedin profile here
>  (http://www.linkedin.com/in/cfliu)
>
>  Is it possible that one of the maintainers could get in touch with him to see:
>
>  * if these mythical drivers were indeed developed, the status of the
>  drivers and the possibility of Qualcomm releasing the source?
>

I never find any clue about this driver.BTW I had contacted with some
people of Airgo company, but all has no response.

>  * the possibility of releasing the complete specifications of the chipset?
>
>  If no one here is the right person to get in touch with David, perhaps
>  someone can point me in the right direction?

I'll retry to get in touch with him.  Thank your support for this project!

BR
Li Yanbo

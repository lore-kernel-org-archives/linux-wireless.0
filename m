Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snt0-omc3-s2.snt0.hotmail.com ([65.55.90.141]:37402 "EHLO
	snt0-omc3-s2.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab0IJHRt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 03:17:49 -0400
Message-ID: <SNT125-W49C691BF5866414B7FCEEAC3740@phx.gbl>
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <machen@novell.com>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: [ANN] Full-source Broadcom wireless driver for 11n chips
Date: Fri, 10 Sep 2010 00:11:38 -0700
In-Reply-To: <AANLkTi=+pZm2bMZUFUsfTwNQHHBzM+yjmzNhim3+KRn0@mail.gmail.com>
References: <20100908150322.17dac9c3@nehalam>,<20100908225132.GA12490@kroah.com>,<4C88F8CE.5090708@broadcom.com>,<loom.20100910T084604-390@post.gmane.org>,<AANLkTi=+pZm2bMZUFUsfTwNQHHBzM+yjmzNhim3+KRn0@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-next-2.6.git;a=tree;f=drivers/staging/brcm80211;hb=a9533e7ea3c410fed2f4cd8b3e1e213e48529b75

________________________________
> Date: Fri, 10 Sep 2010 15:03:53 +0800
> Subject: Re: [ANN] Full-source Broadcom wireless driver for 11n chips
> From: machen@novell.com
> To: yuhongbao_386@hotmail.com
> CC: linux-wireless@vger.kernel.org
>
> Hi all,
> I don't see there is drivers/staging/brcm80211 in
> drivers/staging/brcm80211. Anyone found it yet ?
>
> 2010/9/10 Yuhong Bao
> Henry Ptasinski writes:
>
> >
> > Broadcom would like to announce the initial release of a fully-open
> > Linux driver for it's latest generation of 11n chipsets. The driver,
> > while still a work in progress, is released as full source and uses the
> > native mac80211 stack. It supports multiple current chips (BCM4313,
> > BCM43224, BCM43225) as well as providing a framework for supporting
> > additional chips in the future, including mac80211-aware embedded chips.
> > The README and TODO files included with the sources provide more
> > details about the current feature set, known issues, and plans for
> > improving the driver.
> >
> > The driver is currently available in staging-next git tree, available at:
> >
> >
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> >
> > in the drivers/staging/brcm80211 directory.
>
> This is limited to newer chips. Can you at least authorize redistribution of
> firmware blobs for older chips so that b43-fwcutter won't be needed
> anymore? I
> have such a laptop myself with one of the older chips, and I remember
> the pains
> of having to download it after booting from a LiveCD.
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Matt Chen
> Engineer
> Novell Asia Pacific
> Tel : +886- 2- 27370946 ext 507
> Fax : +886- 2- 27370947
> Novell Making IT Work As One
 		 	   		  
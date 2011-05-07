Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57763 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab1EGQCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 12:02:31 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 07 May 2011 09:02:03 -0700
Date: Sat, 7 May 2011 21:32:22 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Greg KH <greg@kroah.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Vipin Mehta" <Vipin.Mehta@Atheros.com>,
	Naveen Singh <Naveen.Singh@Atheros.com>
Subject: Re: [PATCH 1/2] ath6kl: Remove dead code with undefined
	EXPORT_HCI_BRIDGE_INTERFACE
Message-ID: <20110507160222.GB17465@vasanth-laptop> (sfid-20110507_180245_626198_E3EAD449)
References: <1304524691-12652-1-git-send-email-vasanth@atheros.com> <20110506163320.GA15144@kroah.com> <20110507102907.GC6002@vasanth-laptop> <20110507154228.GD23672@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110507154228.GD23672@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 07, 2011 at 09:12:28PM +0530, Greg KH wrote:
> On Sat, May 07, 2011 at 03:59:07PM +0530, Vasanthakumar Thiagarajan wrote:
> > On Fri, May 06, 2011 at 10:03:20PM +0530, Greg KH wrote:
> > > On Wed, May 04, 2011 at 09:28:10PM +0530, Vasanthakumar Thiagarajan wrote:
> > > > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > > 
> > > It's not as dead as you think it is, this series causes a build
> > > breakage.
> > > 
> > > PLEASE TEST YOUR PATCHES!
> > > 
> > > To not do so, like you did here just makes me grumpy and not want to
> > > deal with them at all...
> > 
> > I'm really sorry for any trouble with those patches. I do compile
> > and test my patches. Unfortunately I do not see the build breakage
> > with that patch series. Can you please share you config file?.
> 
> Attached.

Really sorry again. I mistakenly moved a global variable
to #ifdef ATH_DEBUG_MODULE. As I was testing with debug
enabled I did not hit this issue.

Thanks,

Vasanth

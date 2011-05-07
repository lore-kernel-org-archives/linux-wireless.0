Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:50544 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab1EGK3h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 06:29:37 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 07 May 2011 03:29:09 -0700
Date: Sat, 7 May 2011 15:59:07 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Greg KH <greg@kroah.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Vipin Mehta" <Vipin.Mehta@Atheros.com>,
	Naveen Singh <Naveen.Singh@Atheros.com>
Subject: Re: [PATCH 1/2] ath6kl: Remove dead code with undefined
	EXPORT_HCI_BRIDGE_INTERFACE
Message-ID: <20110507102907.GC6002@vasanth-laptop> (sfid-20110507_122941_358895_01E24EB7)
References: <1304524691-12652-1-git-send-email-vasanth@atheros.com> <20110506163320.GA15144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110506163320.GA15144@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 06, 2011 at 10:03:20PM +0530, Greg KH wrote:
> On Wed, May 04, 2011 at 09:28:10PM +0530, Vasanthakumar Thiagarajan wrote:
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
> It's not as dead as you think it is, this series causes a build
> breakage.
> 
> PLEASE TEST YOUR PATCHES!
> 
> To not do so, like you did here just makes me grumpy and not want to
> deal with them at all...

I'm really sorry for any trouble with those patches. I do compile
and test my patches. Unfortunately I do not see the build breakage
with that patch series. Can you please share you config file?.

Vasanth

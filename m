Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17093 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab0GFGSP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 02:18:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jul 2010 23:18:15 -0700
Date: Tue, 6 Jul 2010 11:48:05 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"greearb@gmail.com" <greearb@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k] ath9k:  Expose virtual wiphy indexes to debugfs.
Message-ID: <20100706061805.GG5053@vasanth-laptop>
References: <1278359545-29013-1-git-send-email-greearb@candelatech.com> <20100706045945.GF5053@vasanth-laptop> <4C32BBF4.9090907@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C32BBF4.9090907@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 06, 2010 at 10:45:32AM +0530, Ben Greear wrote:
> On 07/05/2010 09:59 PM, Vasanthakumar Thiagarajan wrote:
> > On Tue, Jul 06, 2010 at 01:22:25AM +0530, greearb@gmail.com wrote:
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> It is very difficult to map phyX devices to real/virtual
> >> entities because the phyX devices change on module
> >> reload.  This patch makes it slightly easier to
> >> associate virtual phy devices with phyX entities.
> >>
> >
> > It does not make much sense to give an index while creating a new
> > virtual wiphy interface. This is unncessary, only wiphy name
> > matters.
> 
> Will the underlying code allow you to specify a phy name though?  It
> seems to me that once a phyX is used, you cannot have a new phy
> with that name again, even if the old one has been unloaded

Driver has nothing to do with assigning phy names. This is done in
cfg80211.


Vasanth

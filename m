Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43540 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab0D0UXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 16:23:08 -0400
Subject: Re: [Fwd: 2.6.34-rc4/5: iwlagn unusable until reload]
From: reinette chatre <reinette.chatre@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Zhao, Shanyu" <shanyu.zhao@intel.com>,
	LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1272399067.4381.10749.camel@rchatre-DESK>
References: <1272399067.4381.10749.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 13:23:07 -0700
Message-ID: <1272399787.4381.10768.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see now that a new kernel.org bug
(https://bugzilla.kernel.org/show_bug.cgi?id=15862 ) has been created
for this issue. We'll track it there.

Reinette

On Tue, 2010-04-27 at 13:11 -0700, reinette chatre wrote:
> Nico,
> 
> The wireless folks don't really hang out on lkml. I'm forwarding your
> message to the linux-wireless mailing list.
> 
> Reinette
> 
> 
> -------- Forwarded Message --------
> > From: Nico Schottelius <nico-linux-20100427@schottelius.org>
> > To: LKML <linux-kernel@vger.kernel.org>
> > Subject: 2.6.34-rc4/5: iwlagn unusable until reload
> > Date: Tue, 27 Apr 2010 00:49:34 -0700
> > 
> > Hello again!
> > 
> > If I try to use iwlagn on the X201 with
> > 
> > 02:00.0 Network controller: Intel Corporation WiFi Link 6000 Series (rev 35)
> > 
> > and 2.6.34-rc5-00211-gb91ce4d, I get a lot of error and no connection,
> > until I
> > 
> > [root@kr ~]# rmmod iwlagn
> > [root@kr ~]# modprobe iwlagn
> > 
> > Attached dmesg before & after.
> > 
> > Cheers,
> > 
> > Nico
> > 
> 



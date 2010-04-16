Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab0DPUH1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 16:07:27 -0400
Subject: Re: 2.6.33 iwl5350 firmware crash
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	stable@kernel.org
In-Reply-To: <1271442365.14052.13562.camel@rchatre-DESK>
References: <g2rcb0375e11004151408m4a74639cz28e6129054824543@mail.gmail.com>
	 <1271442365.14052.13562.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 13:07:23 -0700
Message-ID: <1271448443.14052.13774.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 11:26 -0700, reinette chatre wrote:
> On Thu, 2010-04-15 at 14:08 -0700, Andrew Lutomirski wrote:
> > [74944.425130] iwlagn 0000:03:00.0: Microcode SW error detected.
> > Restarting 0x2000000.
> > [74944.425154] iwlagn 0000:03:00.0: Start IWL Error Log Dump:
> > [74944.425160] iwlagn 0000:03:00.0: Status: 0x000212E4, count: 5
> > [74944.425291] iwlagn 0000:03:00.0: Desc
> > Time       data1      data2      line
> > [74944.425301] iwlagn 0000:03:00.0: NMI_INTERRUPT_WDG            (#04)
> > 1638059893 0x00000002 0x07030000 3664
> 
> [...]
> 
> > [74981.401945] ------------[ cut here ]------------
> > [74981.401980] WARNING: at net/mac80211/agg-tx.c:152
> > ___ieee80211_stop_tx_ba_session+0x87/0x8c [mac80211]()
> 
> 
> Please see https://bugzilla.kernel.org/show_bug.cgi?id=15374 - it has
> patches that will help aggregation recovery after this NMI problem.
> Unfortunately there is nothing we can do at this time to the firmware
> error. I'll try to get these patches into 2.6.34 today.

The patches are already included in 2.6.34. I did try to get this
included into 2.6.33 and submitted it to stable on 03/18/2010,
unfortunately it was not accepted.

Reinette



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab1BRHs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 02:48:57 -0500
Date: Fri, 18 Feb 2011 08:48:31 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sujith <m.sujith@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wwguy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix conn_mon_timer running after disassociate
Message-ID: <20110218074830.GA2214@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
 <1297698696.4723.16.camel@wwguy-ubuntu>
 <20110215113444.GC2162@redhat.com>
 <1297770602.3935.3.camel@jlt3.sipsolutions.net>
 <20110215130428.GA2515@redhat.com>
 <1297775393.3935.15.camel@jlt3.sipsolutions.net>
 <20110215132202.GC2515@redhat.com>
 <1297776631.3935.16.camel@jlt3.sipsolutions.net>
 <20110216095443.GC2812@redhat.com>
 <19805.55087.117572.853090@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19805.55087.117572.853090@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 07:49:27AM +0530, Sujith wrote:
> I just hit this issue right after unloading ath9k_htc.
> I haven't tested your patch yet.
[snip]
>   [<ffffffff8107425d>] queue_work_on+0x1d/0x30
>   [<ffffffff810742c6>] queue_work+0x36/0x60
>   [<ffffffff810927ad>] ? trace_hardirqs_on_caller+0x5d/0x180
>   [<ffffffffa036757d>] ieee80211_queue_work+0x3d/0x50 [mac80211]
>   [<ffffffffa0351b6f>] ieee80211_sta_conn_mon_timer+0x2f/0x40 [mac80211]

Patch should fix it as well, I think it will be good to have it
applied. I will repost, since seems John miss that patch.

Stanislaw

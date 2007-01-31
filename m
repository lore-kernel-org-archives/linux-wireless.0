Return-path: <wireless-bounces@tuxdriver.com>
Received: from mail.suse.cz (styx.suse.cz [82.119.242.94])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0VJPqlN007688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Wed, 31 Jan 2007 14:26:18 -0500
Date: Wed, 31 Jan 2007 20:25:49 +0100
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] cfg80211 merge
Message-ID: <20070131202549.5ee47bd4@griffin.suse.cz>
In-Reply-To: <20070131183255.GB8776@tuxdriver.com>
References: <20070131013717.GA28076@tuxdriver.com>
	<20070131024807.GA7061@jm.kir.nu>
	<20070131182908.13bfc374@griffin.suse.cz>
	<20070131183255.GB8776@tuxdriver.com>
Mime-Version: 1.0
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com

On Wed, 31 Jan 2007 13:32:55 -0500, John W. Linville wrote:
> OK, where were you guys in London?  I don't recall any disagreement
> there?

Hm, I remember we agreed that merging of d80211 and cfg80211/nl80211
are two separate things. And a discussion about cfg80211/nl80211 not
being quite ready yet (if I remember correctly, Jouni participated in
that discussion). But well, it was just informal and maybe I missed
something else.

> The WEXT compat code should be enough to drive the cfg80211 code.
> And we would mark it CONFIG_EXPERIMENTAL (which I left out of the
> patch) for now.  I suppose we could leave-out the nl80211 part to
> avoid userland lock-in for now?

Yes, that could solve that I think.

> This also has the advantage of including the ieee80211_ptr in the
> net_device structure, hopefully easing the task of packaging the rest
> of the stack for external builds.

Definitely.

> I suppose we could wait for at least one driver to be cfg80211-capable.
> Would that satisfy everyone?

If cfg80211-capable means also WPA-capable and if nl80211 is left out
until user space counterpart exists, yes, I'm okay with that.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

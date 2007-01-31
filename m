Return-path: <wireless-bounces@tuxdriver.com>
Received: from pentafluge.infradead.org (pentafluge.infradead.org
	[213.146.154.40])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0VK82vZ008684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Wed, 31 Jan 2007 15:08:28 -0500
Date: Wed, 31 Jan 2007 20:07:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [RFC] cfg80211 merge
Message-ID: <20070131200741.GA22448@infradead.org>
References: <20070131013717.GA28076@tuxdriver.com>
	<20070131024807.GA7061@jm.kir.nu>
	<20070131182908.13bfc374@griffin.suse.cz>
	<20070131183255.GB8776@tuxdriver.com>
	<20070131202549.5ee47bd4@griffin.suse.cz>
Mime-Version: 1.0
In-Reply-To: <20070131202549.5ee47bd4@griffin.suse.cz>
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

On Wed, Jan 31, 2007 at 08:25:49PM +0100, Jiri Benc wrote:
> On Wed, 31 Jan 2007 13:32:55 -0500, John W. Linville wrote:
> > OK, where were you guys in London?  I don't recall any disagreement
> > there?
> 
> Hm, I remember we agreed that merging of d80211 and cfg80211/nl80211
> are two separate things. And a discussion about cfg80211/nl80211 not
> being quite ready yet (if I remember correctly, Jouni participated in
> that discussion). But well, it was just informal and maybe I missed
> something else.

Yes, cfg80211 should go in first so we can use it to avoid all the
boilerplate code in existing and new drivers.  Once we have netlink-capable
userspace nl80211 can be added ontop of that.  This also allows for
possibly needed adjustments of the nl interface when writing the
tools actually using it.

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44293 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1LFUPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 15:15:14 -0500
Date: Tue, 6 Dec 2011 15:04:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Paul Stewart <pstew@google.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [PATCH 2/4] ath9k: rework power state handling
Message-ID: <20111206200434.GE30288@tuxdriver.com> (sfid-20111206_211519_394928_F3C68ED0)
References: <1321445323-71774-1-git-send-email-nbd@openwrt.org>
 <1321445323-71774-2-git-send-email-nbd@openwrt.org>
 <CAB=NE6XOz9p=GwQWZ3TibMMan70QO7dXgVRP4PLuV6p=P1-RXA@mail.gmail.com>
 <A6331C99-8D86-4CD6-88F2-123B38F31B26@nbd.name>
 <CAB=NE6WLQUqbWoVGC4WgGVFTUJC1i8_um4=sBU-V+NpfW57YHg@mail.gmail.com>
 <CAMcMvsjsCzDH6hpS6Bon-5Zrad5eNf41Zq0ei_iw+MFK41rF=w@mail.gmail.com>
 <4EC44CC6.7090104@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4EC44CC6.7090104@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2011 at 12:52:38AM +0100, Felix Fietkau wrote:
> On 2011-11-16 7:40 PM, Paul Stewart wrote:
> > In fact, could this be made contingent on whether there's an AP-mode
> > interface, since the problem you're encountering seems to only be in
> > AP mode?  What troubles me, Felix, is your statement that " this
> > series fixes some "PCI error" crashes".  Does this mean that you
> > haven't root-caused the problem, and that this may only partially mask
> > it?
> The existing code was wrong, especially for client mode. I only noticed
> that because I was investigating some AP mode crashes triggered by it.
> My main focus when fixing this stuff was actually client mode since
> that's the one most affected by this codepath.

Are we satisfied w/ this series?  Or does it still need work?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

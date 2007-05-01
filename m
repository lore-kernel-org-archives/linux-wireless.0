Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:37185 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbXEARMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 13:12:54 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HivrY-00004w-W6
	for linux-wireless@vger.kernel.org; Tue, 01 May 2007 13:10:05 -0400
Subject: Re: [PATCH] mac80211: mark as experimental
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1178020272.21671.1.camel@localhost.localdomain>
References: <20070430201742.1f53aa40@griffin.suse.cz>
	 <1177969723.26986.30.camel@dv>
	 <1178020272.21671.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 01 May 2007 13:12:48 -0400
Message-Id: <1178039568.11535.7.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-05-01 at 07:51 -0400, Dan Williams wrote:
> On Mon, 2007-04-30 at 17:48 -0400, Pavel Roskin wrote:
> > On Mon, 2007-04-30 at 20:17 +0200, Jiri Benc wrote:
> > > Make the stack depend on EXPERIMENTAL. Also, change the name from "dscape"
> > > to "mac80211".
> > 
> > Why is it needed to make mac80211 EXPERIMENTAL?  With mac80211 already
> > in Ubuntu 7.04 and in the forthcoming Fedora 7, it must have received
> > more testing than some drivers not marked as EXPERIMENTAL.
> 
> It's still just not there yet, especially WRT compatibility behavior for
> WEXT.  I don't know if that justifies EXPERIMENTAL status, but most
> drivers don't appear to be production ready, from user reports.

That's my whole point.  Mark the drivers experimental, not the common
code.

I think the issues affecting WEXT in non-mac80211 drivers by cfg80211
were fixed in December or so.

But anyway, it's better to have "experimental" mac80211 in the kernel
than no mac80211 at all.

-- 
Regards,
Pavel Roskin


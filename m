Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4245 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbXFKTYf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 15:24:35 -0400
Date: Mon, 11 Jun 2007 15:05:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [TAKE 2][PATCH 0/3] IEEE802.11e/WMM TS management and DLS support
Message-ID: <20070611190556.GF10397@tuxdriver.com>
References: <20070525115205.GA23301@mail.intel.com> <20070531180445.GB3706@tuxdriver.com> <200705311255.40416.flamingice@sourmilk.net> <1180659895.3109.104.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1180659895.3109.104.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 01, 2007 at 09:04:54AM +0800, Zhu Yi wrote:
> On Thu, 2007-05-31 at 12:55 -0700, Michael Wu wrote:
> > This is nowhere near ready to go upstream and it requires some bits
> > from the 802.11n patches which didn't make it. 
> 
> Can you speak what is needed for 11n and where to find the 11n patches?

The .11n patches submitted by Intel are available in wireless-dev.
The mac80211 component maintainers don't like them, and since there
is no driver for .11n hardware currently in the mainline kernel
there has not been much impetus to get the patches mainstreamed.
Perhaps when the iwlwifi driver is whipped into shape for upstream
then we will have the necessary motivation?

FWIW, I don't think there has been a very clear discussion about
the .11n patches from Intel.  They need both a more clear defense
from the authors at Intel and a more concrete set of objections
(and hopefully suggestions for improvements that lead to acceptance)
from the mac80211 component team.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com

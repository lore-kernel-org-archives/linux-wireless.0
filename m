Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-86.dex002.intermedia.net ([64.78.20.226]:13494 "EHLO
	dhost002-86.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966117AbXFGW7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 18:59:08 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Thu, 7 Jun 2007 15:59:49 -0700
To: Jiri Benc <jbenc@suse.cz>
Cc: jketreno <jketreno@linux.intel.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
Message-ID: <20070607225949.GL26739@devicescape.com>
References: <4668DBE1.5090201@linux.intel.com> <20070608004909.7322f394@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070608004909.7322f394@logostar.upir.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 08, 2007 at 12:49:09AM +0200, Jiri Benc wrote:
> On Thu, 07 Jun 2007 21:32:33 -0700, jketreno wrote:
> > It doesn't really look like he invented a 'new useless' prefix.  It looks
> > to me like he picked a prefix that correlates attribution of the data
> > declaration to the entity that created it.  You may not like that he
> > provided attribution, but that doesn't mean its useless.
> 
> By "useless", I meant "if you use a WLAN_ prefix like in all other #defines
> in that file, it will do the same job". Ok, I understand the argument about
> attribution, but it shouldn't be in exchange of consistency and clarity.

WLAN_ prefix is currently mostly (only?) used for values defined in
IEEE 802.11 while the WMM parameters are defined in WFA specification,
not IEEE 802.11.

-- 
Jouni Malinen                                            PGP id EFC895FA

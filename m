Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbZHDAfi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 20:35:38 -0400
Subject: Re: [PATCH] ipw2x00: Write outside array bounds
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Roel Kluin <roel.kluin@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090803195118.GD11441@tuxdriver.com>
References: <4A6B7DB0.7090902@gmail.com> <1248660620.3747.102.camel@debian>
	 <20090803195118.GD11441@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 08:35:24 +0800
Message-Id: <1249346124.4069.47.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-08-04 at 03:51 +0800, John W. Linville wrote:
> On Mon, Jul 27, 2009 at 10:10:20AM +0800, Zhu Yi wrote:
> > On Sun, 2009-07-26 at 05:48 +0800, Roel Kluin wrote:
> > > channel_index loops up to IPW_SCAN_CHANNELS, but is used after being
> > > incremented. This might be able to access 1 past the end of the array
> > > 
> > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > 
> > Thanks. Do you think below patch is better?
> 
> Didn't see an answer here...which patch do we want?

Please apply mine.

Thanks,
-yi


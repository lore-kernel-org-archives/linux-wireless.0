Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42535 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZHCUBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 16:01:06 -0400
Date: Mon, 3 Aug 2009 15:51:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Roel Kluin <roel.kluin@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ipw2x00: Write outside array bounds
Message-ID: <20090803195118.GD11441@tuxdriver.com>
References: <4A6B7DB0.7090902@gmail.com> <1248660620.3747.102.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1248660620.3747.102.camel@debian>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 10:10:20AM +0800, Zhu Yi wrote:
> On Sun, 2009-07-26 at 05:48 +0800, Roel Kluin wrote:
> > channel_index loops up to IPW_SCAN_CHANNELS, but is used after being
> > incremented. This might be able to access 1 past the end of the array
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> Thanks. Do you think below patch is better?

Didn't see an answer here...which patch do we want?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!

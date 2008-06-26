Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3346 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYFZSQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:16:58 -0400
Date: Thu, 26 Jun 2008 13:55:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: Re: [PATCH 1/2] mac80211: add power management support
Message-ID: <20080626175507.GA23142@tuxdriver.com> (sfid-20080626_201701_325174_F72A9F8D)
References: <200711161929.36283.mboton.lkml@gmail.com> <200711161953.26801.mboton.lkml@gmail.com> <20080626174058.GA3063@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20080626174058.GA3063@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2008 at 07:40:58PM +0200, Samuel Ortiz wrote:
> Hi John,
>=20
> On Fri, Nov 16, 2007 at 07:53:26PM +0100, Miguel Bot=F3n wrote:
> > Ok, the previous patch had a little error.
> >=20
> > --
> >=20
> > This patch adds power management support in mac80211.
> Sorry for being late to the game, but would a similar patch against y=
our
> -next-2.6 tree be considered for inclusion ?

It seems like a reasonable start to me.  Anyone else have comments?

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

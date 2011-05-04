Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1EDQeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 12:34:36 -0400
Subject: Re: [PATCH 01/13] nl80211: Introduce
 NL80211_MESH_SETUP_USERSPACE_AMPE
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <BANLkTi=Xr1z_of+x=_yxxpBB-gwqZJ8-Zw@mail.gmail.com> (sfid-20110504_183315_763592_EA6A2489)
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
	 <1304467039-7730-2-git-send-email-javier@cozybit.com>
	 <1304512025.3563.12.camel@jlt3.sipsolutions.net>
	 <BANLkTi=Xr1z_of+x=_yxxpBB-gwqZJ8-Zw@mail.gmail.com>
	 (sfid-20110504_183315_763592_EA6A2489)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 18:34:32 +0200
Message-ID: <1304526872.3563.22.camel@jlt3.sipsolutions.net> (sfid-20110504_183439_409349_F860A12B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-04 at 09:32 -0700, Javier Cardona wrote:
> On Wed, May 4, 2011 at 5:27 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2011-05-03 at 16:57 -0700, Javier Cardona wrote:
> >
> >> These patches introduce support for Authenticated Mesh Peering Exchange
> >> in userspace.  The userspace daemon implements the AMPE protocol and on
> >> successfull completion create mesh peers and install encryption keys.
> >
> > Do all combinations make sense? I mean, I can sort of see that you can
> > have authenticated but unsecured, but secured and unauthenticated?
> 
> Probably not.  I'm not 100% sure.

I was just wondering if it should be allowed at all.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1LHKje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 05:39:34 -0500
Subject: Re: [PATCH 1/2] ieee80211: Introduce ieee80211_has_frags
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAGXE3d-qyXB7cEaDM6-21FttyF6iNNGRG1_madFVC9d25X6tRA@mail.gmail.com> (sfid-20111208_104224_327728_48CD5980)
References: <1323336114-31203-1-git-send-email-helmut.schaa@googlemail.com>
	 <1323336302.3332.7.camel@jlt3.sipsolutions.net>
	 <1323336406.3332.9.camel@jlt3.sipsolutions.net>
	 <CAGXE3d-qyXB7cEaDM6-21FttyF6iNNGRG1_madFVC9d25X6tRA@mail.gmail.com>
	 (sfid-20111208_104224_327728_48CD5980)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 11:39:32 +0100
Message-ID: <1323340772.3332.31.camel@jlt3.sipsolutions.net> (sfid-20111208_113936_554229_6EB43939)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 10:41 +0100, Helmut Schaa wrote:
> On Thu, Dec 8, 2011 at 10:26 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >> Would _is_frag() read nicer? The piece you're checking is a fragment I
> >> think?
> >
> > Never mind ... the first fragment has is a fragment too and doesn't
> > return true here.
> 
> We could also call it ieee80211_is_first_frag and swap the logic?

That seems like a good idea.

johannes


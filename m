Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1LHKjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 05:39:17 -0500
Subject: Re: [PATCH 1/2] ieee80211: Introduce ieee80211_has_frags
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAGXE3d_Cytq=a--29KN8K5NGi=zw1ywhUV=hDqYioWbvt5Uo4A@mail.gmail.com> (sfid-20111208_103904_661326_0E9936DC)
References: <1323336114-31203-1-git-send-email-helmut.schaa@googlemail.com>
	 <1323336302.3332.7.camel@jlt3.sipsolutions.net>
	 <CAGXE3d_Cytq=a--29KN8K5NGi=zw1ywhUV=hDqYioWbvt5Uo4A@mail.gmail.com>
	 (sfid-20111208_103904_661326_0E9936DC)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 11:39:14 +0100
Message-ID: <1323340754.3332.30.camel@jlt3.sipsolutions.net> (sfid-20111208_113922_374203_3433CB58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 10:38 +0100, Helmut Schaa wrote:
> On Thu, Dec 8, 2011 at 10:25 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >> +{
> >> +     return (seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)) != 0;
> >> +}
> >> +
> >
> > Maybe you should move that close to ieee80211_has_morefrags() so it's
> > easy to tell the difference? :-) (that doesn't use bool either, heh)
> 
> Since all ieee80211_is/has_* functions use int already I took the same
> approach.
> 
> And ieee80211_has_morefrags operates on the frame control while
> this operates on seq_ctrl. Hence, I placed it at the end but if you prefer
> to have it closer to ieee80211_has_morefrags I can do that too :)

Oh, well, whatever, I don't really care :)

johannes


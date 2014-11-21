Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53740 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523AbaKUJtA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 04:49:00 -0500
Message-ID: <1416563318.1881.2.camel@sipsolutions.net> (sfid-20141121_104905_153658_B6932C44)
Subject: Re: [PATCH v3] mac80211: keep sending peer candidate events while
 in listen state
From: Johannes Berg <johannes@sipsolutions.net>
To: "Nishikawa, Kenzoh" <Kenzoh.Nishikawa@jp.sony.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"Bob Copeland (me@bobcopeland.com)" <me@bobcopeland.com>
Date: Fri, 21 Nov 2014 10:48:38 +0100
In-Reply-To: <1416563244.1881.1.camel@sipsolutions.net> (sfid-20141121_104759_725228_CF4DFC5E)
References: <2EB4F5C65A3B8E4E92660930F4EF6B5B06C8BC@JPYOKXMS113.jp.sony.com>
	 (sfid-20141121_101258_074290_AAFA54B9) <1416563244.1881.1.camel@sipsolutions.net>
	 (sfid-20141121_104759_725228_CF4DFC5E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-21 at 10:47 +0100, Johannes Berg wrote:

> > +	else if (sta->plink_state == NL80211_PLINK_LISTEN &&
> > +		(sdata->u.mesh.user_mpm ||
> > +		sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED))
> 
> the latter two lines should be indented by one more space

Actually the third by 2 to match the containing parenthesis.

johannes


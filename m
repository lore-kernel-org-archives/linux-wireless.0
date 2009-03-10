Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38333 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753827AbZCJWob (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 18:44:31 -0400
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 10 Mar 2009 23:44:27 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1236669682.9658.34.camel@johannes.local>
Message-ID: <20090310224427.223760@gmx.net> (sfid-20090310_234434_313074_3AE46274)
MIME-Version: 1.0
References: <20090309234946.99940@gmx.net>	
 (sfid-20090310_005017_999744_57F45C40)
 <1236669682.9658.34.camel@johannes.local>
Subject: Re: [PATCH] mac80211: ieee80211_ibss_commit() cleanup
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

> And now to explain why this is desired?

=46or unification with the STA implementation and besides it fixes a bu=
g, that ieee80211_sta_find_ibss() is triggered while the interface is d=
own and do some strange things that it shouldn't do in this interface s=
tate.

> Are you going to post "commit"
> patches again that I will reject?

This has nothing to do with the current patch and should discussed else=
where.

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

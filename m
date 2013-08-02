Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:32953 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3HBFOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 01:14:46 -0400
Received: by mail-ve0-f179.google.com with SMTP id c13so210037vea.24
        for <linux-wireless@vger.kernel.org>; Thu, 01 Aug 2013 22:14:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375343068.8608.11.camel@jlt4.sipsolutions.net>
References: <1375148892-18121-1-git-send-email-yeohchunyeow@cozybit.com>
	<1375343068.8608.11.camel@jlt4.sipsolutions.net>
Date: Fri, 2 Aug 2013 13:14:45 +0800
Message-ID: <CAEFj987LHjuhm0Makzju2QE7o8w=Xm_Az7ejo_KfL0PZRjWVsw@mail.gmail.com> (sfid-20130802_071449_460319_31D57944)
Subject: Re: [PATCH] mac80211: allow lowest basic rate for unicast management
 frame in mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "devel@lists.open80211s.org" <devel@lists.open80211s.org>
Cc: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> That doesn't seem like a good idea - IMHO you shouldn't use container_of
> on NULL even if it still works in the end.
>
> Also it might be a good idea to use more regular names: struct
> ieee80211_sta *pubsta, struct sta_info *sta.

Ok.

> I don't get this - that just duplicates the code above, no chance to
> refactor it a bit instead of duplicating the call?

I will take a look on this first.

---
Chun-Yeow

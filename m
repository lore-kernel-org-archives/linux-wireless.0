Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab1JLIhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:37:21 -0400
Subject: Re: [PATCH] iw: add DFS region parsing support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <CAB=NE6WtkokxWg4zJtjyKVZmhZAhzArfoJuOOqhuKSw940hxqg@mail.gmail.com> (sfid-20111011_222559_297938_090E0777)
References: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
	 <1318355944-24708-8-git-send-email-mcgrof@qca.qualcomm.com>
	 <1318363042.15357.0.camel@jlt3.sipsolutions.net>
	 <CAB=NE6WtkokxWg4zJtjyKVZmhZAhzArfoJuOOqhuKSw940hxqg@mail.gmail.com>
	 (sfid-20111011_222559_297938_090E0777)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:37:14 +0200
Message-ID: <1318408634.3933.32.camel@jlt3.sipsolutions.net> (sfid-20111012_103733_415289_0C28119E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 13:25 -0700, Luis R. Rodriguez wrote:

> > Also, I prefer patches w/o nl80211.h updates.
> 
> In my RFC on December the stars aligned differently and you preferred
> it together I think.

Really? I must've been confused. The reason I don't want them is that
then I can never merge something that isn't upstream yet. :)

johannes


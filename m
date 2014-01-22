Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41146 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbaAVPKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 10:10:36 -0500
Message-ID: <1390403432.4334.33.camel@jlt4.sipsolutions.net> (sfid-20140122_161039_409593_ABCA2C07)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 16:10:32 +0100
In-Reply-To: <1390394166.4189.28.camel@porter.coelho.fi>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 (sfid-20140122_111301_086907_C6814DB8) <1390385995.4334.27.camel@jlt4.sipsolutions.net>
	 <1390394166.4189.28.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 14:36 +0200, Luca Coelho wrote:

> I don't think we should try to merge the channel switches.  We should
> just perform them separately, especially because the exact time of the
> switch will most likely not be the same (since the TBTTs are not in
> sync).

Do you mean that we shouldn't even have all that new API to switch
multiple interfaces simultaneously?

johannes


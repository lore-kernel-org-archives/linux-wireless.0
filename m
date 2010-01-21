Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:42880 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430Ab0AUKIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 05:08:11 -0500
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id hb0jom0171ss for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 15:38:05 +0530 (envelope-from <andrit@ukr.net>)
Message-ID: <4B58277A.5030308@ukr.net>
Date: Thu, 21 Jan 2010 12:07:54 +0200
From: Andriy Tkachuk <andrit@ukr.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: Account HT Control field in Data frame hdrlen
 according to 802.11n-2009
References: <4B56EF1A.4050503@ukr.net> <43e72e891001201008w29da1feka88b6859d7feb91a@mail.gmail.com>
In-Reply-To: <43e72e891001201008w29da1feka88b6859d7feb91a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-20 20:08, Luis R. Rodriguez wrote:
> Very nice, thanks for the fuller commit log. Hm, the question I also
> wanted to address was whether or not this is a stable fix to go for
> 2.6.32 and 2.6.33, I suppose we'd have to look at all callers of
> ieee80211_hdrlen() but this seems like a stable fix to me.

As I already said, I would rather classify this change as a feature then
a fix, so I would advise to give the code more time for breaking-in
starting from the current branch and not put the stable at an odd risk
(which seem to be the minor one, though).

Regards,
    Andriy

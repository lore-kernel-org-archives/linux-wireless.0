Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47781 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1CETky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 14:40:54 -0500
Received: by vws12 with SMTP id 12so2839665vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Mar 2011 11:40:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299333960.3826.6.camel@jlt3.sipsolutions.net>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com> <1299333960.3826.6.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Sat, 5 Mar 2011 11:40:33 -0800
Message-ID: <AANLkTi=sP0-cjuDu1XYGB2+UzHjyD_i1854AJQ=A4Bfn@mail.gmail.com>
Subject: Re: [PATCH 0/4 v2] {mac|nl}80211: Support for SAE mesh authentication
 in userspace
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 5, 2011 at 6:06 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> I have a more generic question since I haven't seen the userspace bits:
There's a working prototype here:
https://github.com/cozybit/authsae/blob/master/linux/meshd-nl80211.c
The intent is to merge that functionality into wpa_supplicant at some point.

> How does userspace know when to authenticate with a new peer?
Authentication is triggered by the reception of a beacon or presp from
a compatible mesh peer with security enabled.

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com

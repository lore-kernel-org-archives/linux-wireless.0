Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:47110 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbaCNJ1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 05:27:54 -0400
Received: by mail-ie0-f177.google.com with SMTP id rl12so2252448iec.22
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 02:27:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGVrzcaWBAo3kiQ5jLKv_XMyuUL-pf1Vj2kL8E8YVnLrm4Mj7A@mail.gmail.com>
References: <CAGVrzcaWBAo3kiQ5jLKv_XMyuUL-pf1Vj2kL8E8YVnLrm4Mj7A@mail.gmail.com>
Date: Fri, 14 Mar 2014 10:26:48 +0100
Message-ID: <CAGXE3d9s-FjVWF-y1n8Zrgzz3YZJ-yNnEQNoVeMfZYJRfbdXTA@mail.gmail.com> (sfid-20140314_102758_154370_9EC8162E)
Subject: Re: skb->priority magic values as part of UAPI headers?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 13, 2014 at 6:04 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> While browsing through net/wireless/util.c::cfg80211_classify8021d() I
> stumbled upon the "magic values" range 256 to 263, should not those be
> made part of some sort of user-space API header file, just so if
> things need to be changed, they suddenly do not break?

I stumbled over that some time ago as well [1].
The question is if this is required at all anymore or if it could just
be removed.
Helmut

[1] http://comments.gmane.org/gmane.linux.kernel.wireless.general/82689

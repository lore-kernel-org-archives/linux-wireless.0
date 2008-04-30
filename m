Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:14291 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbYD3PEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 11:04:39 -0400
Received: by wf-out-1314.google.com with SMTP id 28so438221wfc.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2008 08:04:39 -0700 (PDT)
Message-ID: <911e063c0804300804y1c26571cn421a01987fc8a264@mail.gmail.com> (sfid-20080430_170431_446913_2FD8A3AC)
Date: Wed, 30 Apr 2008 17:04:39 +0200
From: "Maxime COSTE" <frrrwww@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: willing to work on a configfs interface
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1209565065.18659.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <911e063c0804300129j4043e889i4fb670fcb10f4963@mail.gmail.com>
	 <1209565065.18659.22.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I've got no real reason to work on configfs rather than cfg80211
beside loving the idea of configuring my wireless through a
filesystem... and also it seemed to be rather straightforward so I
thought it was a good way to enter linux kernel hacking. I have no
problem working on the cfg80211 API if it's what really needs work
now.

I'll take a look at the current todo-list.

Maxime.


2008/4/30 Johannes Berg <johannes@sipsolutions.net>:
> Hi Maxime,
>
>
>
>  > I'm willing to work on the linux kernel, and I thought that a configfs
>  > interface for the cfg80211 module would be great, I would like to know
>  > if someone is already working on that, and if there is any reason not
>  > to do it.
>
>  Well, the foremost reason not to do configfs it is that even nl80211
>  doesn't really offer much functionality yet. Is there any specific
>  reason why you want configfs rather than netlink? Would you want to work
>  on adding more cfg80211 API (especially for STA MLME)?
>
>  johannes
>

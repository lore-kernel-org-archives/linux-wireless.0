Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65125 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab2EHSj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 14:39:27 -0400
Received: by bkcji2 with SMTP id ji2so4903813bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 11:39:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFED-jk73hMn-ryTPgP4tpowZEXa1SL4XWbjrX43mpR7kQ0CKA@mail.gmail.com>
References: <1319350901-31178-1-git-send-email-arik@wizery.com>
 <4EA7DA0F.7050603@sipsolutions.net> <CA+XVXff+4SLy6y2xbDONDOg_j9CNYd1rkLgtdvHEKpprBW5zog@mail.gmail.com>
 <CAFED-jku-zGtTvYwGpwCastRJZAfQf9uyJAeqtevGVRn22Qygg@mail.gmail.com>
 <1336392314.4325.26.camel@jlt3.sipsolutions.net> <CA+XVXfdHiCMo6Ro1BVRen1qbFQAhd0cGKWk2ZSsFeHG01eZxig@mail.gmail.com>
 <CAFED-jk73hMn-ryTPgP4tpowZEXa1SL4XWbjrX43mpR7kQ0CKA@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 8 May 2012 21:39:10 +0300
Message-ID: <CA+XVXfd3BYOik5d=F_pOEXOwo7wG_LMkj6bEsWe9Hha-dYLRXA@mail.gmail.com> (sfid-20120508_203939_808794_C4958435)
Subject: Re: [PATCH] mac80211: support adding IV-room in the skb for CCMP keys
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 8, 2012 at 12:23 PM, Janusz Dziedzic
<janusz.dziedzic@gmail.com> wrote:
>
> Patch proposal:
> Verified with cw1200 + WEP, TKIP, CCMP.
> As I understand correctly selection (PUT_IV_SPACE flag) will be done
> in set_key() driver callback, so driver could select if need this
> based on cipher param.

You're right of course. The flag is harmless if we don't it in the
appropriate key_conf->flags. Patch looks good to me.

Arik

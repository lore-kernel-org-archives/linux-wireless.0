Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:49371 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbXDFWy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 18:54:26 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1241117uga
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2007 15:54:25 -0700 (PDT)
Message-ID: <1ba2fa240704061554t489c5efahb60472c9385a324c@mail.gmail.com>
Date: Sat, 7 Apr 2007 01:54:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John Linville" <linville@tuxdriver.com>
Subject: Re: mac80211 debugfs compile failure
Cc: "Michael Buesch" <mb@bu3sch.de>, "Jiri Benc" <jbenc@suse.cz>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <4616CD15.80405@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252;
	format=flowed
References: <200704070028.02143.mb@bu3sch.de> <4616CD15.80405@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John
Can you give this patch some higher priority. It's not nice to have a
compilation breakage for so long time in the 'main' branch.
Thanks
Tomas

On 4/7/07, Daniel Drake <dsd@gentoo.org> wrote:
> Michael Buesch wrote:
> > net/mac80211/debugfs.c: In function =E2=80=98stats_wme_rx_queue_rea=
d=E2=80=99:
> > net/mac80211/debugfs.c:266: error: =E2=80=98struct ieee80211_local=E2=
=80=99 has no member named =E2=80=98wme_rx_queue=E2=80=99
> > net/mac80211/debugfs.c: In function =E2=80=98stats_wme_tx_queue_rea=
d=E2=80=99:
> > net/mac80211/debugfs.c:286: error: =E2=80=98struct ieee80211_local=E2=
=80=99 has no member named =E2=80=98wme_tx_queue=E2=80=99
> > make[2]: *** [net/mac80211/debugfs.o] Error 1
> > make[1]: *** [net/mac80211] Error 2
> > make: *** [net] Error 2
> >
> > Seems like some ifdefs missing or something. Does a patch exist?
> >
>
>  From Johannes:
> [PATCH] fix debugfs compile w/o debug counters
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

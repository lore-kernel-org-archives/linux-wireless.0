Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:30325 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXLMOjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 09:39:41 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1114497wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2007 06:35:27 -0800 (PST)
Message-ID: <1ba2fa240712130635n44838ac4s5bb606e5dc27fdeb@mail.gmail.com> (sfid-20071213_143945_092983_8749E8B7)
Date: Thu, 13 Dec 2007 16:35:27 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [FYI] hostapd with mac80211 progress
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>, hostap <hostap@shmoo.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1197512614.6558.224.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197512614.6558.224.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Ron, have you started working on traffic flows for hostapd yet? If so, I
> guess I should set up a git tree or simply push all my hostapd patches
> to Jouni (and send fixes as I find the bugs) because otherwise we're
> going to produce many conflicts, most of my changes are quite large.
> OTOH, I guess the only thing you need to do in the nl80211 driver stuff
> is add support for flows to the station management. Let me know how you
> want to proceed.
>

I take this question instead of Ron.
We have mostly configuration patches - (enhanced hostap_ioctls.h)  and
some minor changes in hostapd flows that we would like to rebase over
your changes to nl80211/mac80211 and hostap respectively. We can start
with 11n Association flows patches.
It would be great if you can setup git repository. Unfortunately it's
rather complicated to export one from Intel.
Thanks
Tomas


> All, any help with hostapd would be much appreciated. In case I forget
> to publish my hostapd patches though, ping me rather than working from
> older ones. Any patches older than this mail are too old.
>
> johannes
>
> _______________________________________________
> HostAP mailing list
> HostAP@shmoo.com
> http://lists.shmoo.com/mailman/listinfo/hostap
>
>

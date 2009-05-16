Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:39938 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZEPVQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 17:16:44 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1544694wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 14:16:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242391067.5799.53.camel@johannes.local>
References: <1242391067.5799.53.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 16 May 2009 14:16:26 -0700
Message-ID: <43e72e890905161416n5295e5eamd4cf41fa1129260d@mail.gmail.com>
Subject: Re: [PATCH] mac80211: cancel/restart all timers across suspend/resume
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 15, 2009 at 5:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:

> --- wireless-testing.orig/net/mac80211/mlme.c   2009-05-15 12:43:11.000000000 +0200
> +++ wireless-testing/net/mac80211/mlme.c        2009-05-15 12:43:11.000000000 +0200
> @@ -37,6 +37,9 @@
>  #define IEEE80211_PROBE_IDLE_TIME (60 * HZ)
>  #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
>
> +#define TMR_RUNNING_TIMER      1
> +#define TMR_RUNNING_CHANSW     1

Typo?

  Luis

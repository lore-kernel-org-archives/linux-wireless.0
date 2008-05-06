Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:31500 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbYEFKq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 06:46:59 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1284582waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 03:46:58 -0700 (PDT)
Message-ID: <1ba2fa240805060346r617a53d1qb421f3d71ec14a1d@mail.gmail.com> (sfid-20080506_124654_643661_7E501734)
Date: Tue, 6 May 2008 13:46:58 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 25/25] iwlwifi: map A-MPDU HW queue to mac80211 A-MPDU SW queue
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1210070251.13316.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-25-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-26-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240805060209x3765abf6lf5ece51055b0d60@mail.gmail.com>
	 <1ba2fa240805060211j3730f29w30313dcb3fd34c44@mail.gmail.com>
	 <1210066688.8012.75.camel@johannes.berg>
	 <1ba2fa240805060334y2add302aua2e4461451a3f95b@mail.gmail.com>
	 <1210070251.13316.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 6, 2008 at 1:37 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>  > >  > >  Is this going to make it to 2.6.26?
>  > >  > >  Without this it will be hard to run 5000 under 2.6.26 as is.
>  > >  >
>  > >  > I meant 'QoS related cleanups'
>  > >
>  > >  Oh. No, I don't think so, unless you can somehow sell it to Linus as a
>  > >  bugfix ;)
>  > >
>  > I will think of a bug :)
>
>  And John and Davem too of course ;)
>
>
>  > >  Disable the 5000 in that kernel and make people use compat?
>  >
>  > Huh, why disabling?
>
>  Well if it's not going to work then wouldn't disabling it be better so
>  people realise it won't work?

5000 won't be in vanilla 2.6.26 so there is nothing to disable. Hoped
just that I won't need
compat so back porting will be reduced to driver and not to mac80211
i.e. kernel.

>
>  Anyway, for all I care that patch can go into .26 but it's fairly large
>  and probably depends on the other two too. Also, it's broken as-is, I
>  sent a fix recently.

Got it.

>  johannes
>

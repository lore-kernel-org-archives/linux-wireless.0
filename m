Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:16095 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYEFKeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 06:34:15 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1613748rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 03:34:15 -0700 (PDT)
Message-ID: <1ba2fa240805060334y2add302aua2e4461451a3f95b@mail.gmail.com> (sfid-20080506_123333_275165_F1FA15F3)
Date: Tue, 6 May 2008 13:34:14 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 25/25] iwlwifi: map A-MPDU HW queue to mac80211 A-MPDU SW queue
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1210066688.8012.75.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-25-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-26-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240805060209x3765abf6lf5ece51055b0d60@mail.gmail.com>
	 <1ba2fa240805060211j3730f29w30313dcb3fd34c44@mail.gmail.com>
	 <1210066688.8012.75.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 6, 2008 at 12:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Tue, 2008-05-06 at 12:11 +0300, Tomas Winkler wrote:
>  > On Tue, May 6, 2008 at 12:09 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>  > > On Mon, May 5, 2008 at 5:22 AM, Zhu Yi <yi.zhu@intel.com> wrote:
>  > >  > From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>  > >  >
>  > >  >  This patch maps A-MPDU HW queue to mac80211 SW queue scheme (as introduced
>  > >  >  in patch "mac80211: QoS related cleanups"), when trying to perform
>  > >  >  ieee80211_wake_queue.
>  > >  >
>  > >  >  Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>  > >  >
>  > >
>  > >  Is this going to make it to 2.6.26?
>  > >  Without this it will be hard to run 5000 under 2.6.26 as is.
>  >
>  > I meant 'QoS related cleanups'
>
>  Oh. No, I don't think so, unless you can somehow sell it to Linus as a
>  bugfix ;)
>
I will think of a bug :)

>  Disable the 5000 in that kernel and make people use compat?

Huh, why disabling?

>
>  johannes
>

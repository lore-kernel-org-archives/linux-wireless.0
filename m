Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:47314 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbXISPFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 11:05:07 -0400
Received: by rv-out-0910.google.com with SMTP id k20so207447rvb
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2007 08:05:06 -0700 (PDT)
Message-ID: <1ba2fa240709190805i6b703e0w885390a78eda9bdc@mail.gmail.com>
Date: Wed, 19 Sep 2007 17:05:06 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: add sta_notify callback
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1190204934.4414.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1190036530108-git-send-email-tomas.winkler@intel.com>
	 <1190054680.23521.23.camel@johannes.berg>
	 <1ba2fa240709180951v3dc0a98ay11205296fd5768a@mail.gmail.com>
	 <1190197117.4414.0.camel@johannes.berg>
	 <1ba2fa240709190438o5032df52mb22a97546bdbe563@mail.gmail.com>
	 <1190204934.4414.17.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/19/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-09-19 at 13:38 +0200, Tomas Winkler wrote:
>
> > Yes, yet I'm not sure I want to deal with it right now.
>
> Well, my patch making sta_info be per-if isn't ready yet either.
> However, once I finish that patch I'll have to touch this callback to be
> correct, and then I will need to fix iwlwifi for using it which is not
> really nice. Hence, I would very much prefer if this callback was
> correctly defined in the first place and the driver simply ignored the
> extra information it currently doesn't need.
>

I will do this favor for you :)  I will prepare another patch.
Tomas

> johannes
>
>

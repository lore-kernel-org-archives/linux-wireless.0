Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:10509 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888AbXISLik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 07:38:40 -0400
Received: by wa-out-1112.google.com with SMTP id v27so200860wah
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2007 04:38:39 -0700 (PDT)
Message-ID: <1ba2fa240709190438o5032df52mb22a97546bdbe563@mail.gmail.com>
Date: Wed, 19 Sep 2007 13:38:39 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: add sta_notify callback
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1190197117.4414.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1190036530108-git-send-email-tomas.winkler@intel.com>
	 <1190054680.23521.23.camel@johannes.berg>
	 <1ba2fa240709180951v3dc0a98ay11205296fd5768a@mail.gmail.com>
	 <1190197117.4414.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/19/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2007-09-18 at 18:51 +0200, Tomas Winkler wrote:
>
> > Actually I'm interested in this feature 4965AGN HW supports multiple
> > MAC addresses.
>
> > > so, would the firmware be able to distinguish between the same STA
> > > sending WDS frames and trying to associate?
>
> > Yes it will
>
> So that means you should add the if_id to the sta callback, no?
>
Yes, yet I'm not sure I want to deal with it right now. I have no use
for it currently
I will add it in next stage  there are no objections. I don't think
I'm breaking anything right now.

> johannes
>
>

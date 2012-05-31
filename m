Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab2EaNHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 09:07:15 -0400
Message-ID: <1338469632.9102.6.camel@jlt3.sipsolutions.net> (sfid-20120531_150718_829540_491DD11B)
Subject: Re: [PATCH v3] mac80211: add command to get current rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 31 May 2012 15:07:12 +0200
In-Reply-To: <CAK80WHYMUtNLg-RcppWc8h561+tLi3P0GE9iY+LV8YnbJyYgrA@mail.gmail.com>
References: <1338467755-8331-1-git-send-email-victorg@ti.com>
	 <1338468480.9102.5.camel@jlt3.sipsolutions.net>
	 <CAK80WHYMUtNLg-RcppWc8h561+tLi3P0GE9iY+LV8YnbJyYgrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-31 at 16:06 +0300, Goldenshtein, Victor wrote:
> On Thu, May 31, 2012 at 3:48 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-05-31 at 15:35 +0300, Victor Goldenshtein wrote:
> >
> >> +DEFINE_EVENT(local_sdata_evt, drv_get_rssi,
> >> +     TP_PROTO(struct ieee80211_local *local,
> >> +              struct ieee80211_sub_if_data *sdata),
> >> +     TP_ARGS(local, sdata)
> >> +);
> >
> > Shouldn't that also trace the station?
> >
> 
> I don't know, what you think we should trace there ?

There are some helper macros for tracing the station, I think they just
have the MAC address

johannes



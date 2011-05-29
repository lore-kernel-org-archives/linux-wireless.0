Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41311 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab1E2PhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 11:37:20 -0400
Received: by iwn34 with SMTP id 34so2423440iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 08:37:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306524533.11997.2.camel@Nokia-N900-51-1>
References: <1306506242-7552-1-git-send-email-lrodriguez@atheros.com> <1306524533.11997.2.camel@Nokia-N900-51-1>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 29 May 2011 08:37:00 -0700
Message-ID: <BANLkTi=ATCCpnH=3Wk-125W82zPgXFJTrQ@mail.gmail.com> (sfid-20110529_173724_577665_FD008D83)
Subject: Re: [PATCH] cfg80211: skip disabled channels on channel survey
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 27, 2011 at 12:28 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> The channel survey information will be empy for
>> disabled channels so simply discard those entries.
>
> What if the channel was recently disabled?

Then we'd stop sending survey data for it.

  Luis

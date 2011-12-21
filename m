Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54288 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab1LUQE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 11:04:57 -0500
Received: by ghbz12 with SMTP id z12so4896999ghb.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 08:04:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324480529.3401.8.camel@jlt3.sipsolutions.net>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1324406771-7100-6-git-send-email-rodrigue@qca.qualcomm.com> <1324480529.3401.8.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 21 Dec 2011 08:04:35 -0800
Message-ID: <CAB=NE6XUPzFrc=Rbn7GwGMwxg9jMncMdjJExU41+TCCKcNU0aQ@mail.gmail.com> (sfid-20111221_170500_645831_E112B98C)
Subject: Re: [PATCH 5/6] ath5k: avoid sparse warnings on tracing
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 7:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-12-20 at 10:46 -0800, Luis R. Rodriguez wrote:
>
>> Just skip the sparse checks on tracing.
>
> I seem to remember removing that elsewhere since newer sparse or newer
> tracing code worked fine together.

I got the complaint from sparse v0.4.3 and saw that iwlwifi, mac80211
used the same technique.

  Luis

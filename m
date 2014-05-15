Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:43690 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaEOJ2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 05:28:45 -0400
Received: by mail-ig0-f179.google.com with SMTP id hn18so732427igb.12
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 02:28:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400078561.4759.12.camel@jlt4.sipsolutions.net>
References: <1400066704-7286-1-git-send-email-janusz.dziedzic@tieto.com>
	<1400078561.4759.12.camel@jlt4.sipsolutions.net>
Date: Thu, 15 May 2014 12:28:44 +0300
Message-ID: <CAB3XZEcixQDE7FbvJ2k3jw501BjS2_LkKG72zYok6WbmzCxq5A@mail.gmail.com> (sfid-20140515_112849_577892_035C05D4)
Subject: Re: [PATCH] cfg80211: fix start_radar_detection issue
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho, Luciano" <luciano.coelho@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 14, 2014 at 5:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-14 at 13:25 +0200, Janusz Dziedzic wrote:
>> After patch:
>> cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
>>
>> start_radar_detection always fail with -EINVAL.
>
> Applied, thanks.
>
probably a bit late, but i don't really see why passing
NL80211_IFTYPE_UNSPECIFIED at all, instead of the iftype?

Eliad.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39016 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2G0J0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 05:26:55 -0400
Received: by obbuo13 with SMTP id uo13so4019369obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 02:26:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343381009.4449.1.camel@jlt3.sipsolutions.net>
References: <1343380724-4104-1-git-send-email-eliad@wizery.com>
	<1343381009.4449.1.camel@jlt3.sipsolutions.net>
Date: Fri, 27 Jul 2012 12:26:55 +0300
Message-ID: <CAB3XZEcskadVAo8XSnLzhEPhCX-qSVjre+Xb9SOz2LL11gycaw@mail.gmail.com> (sfid-20120727_112659_318916_303957CA)
Subject: Re: [PATCH v2] mac80211: add PS flag to bss_conf
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 27, 2012 at 12:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Looks good, but please undo this change:
>
>> +bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata);
>
>> -static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
>> +bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
>
> since I don't see that you need it now.
>
sure. thanks.

Eliad.

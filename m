Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34232 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaBCKoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 05:44:00 -0500
Received: by mail-ie0-f174.google.com with SMTP id tp5so6157401ieb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 02:43:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391422193.4488.2.camel@jlt4.sipsolutions.net>
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEc94pTAMXWPYeWhu7o_YLEnD1_9O035-+YXYiR0Uij28w@mail.gmail.com>
	<1390810765.4251.0.camel@jlt4.sipsolutions.net>
	<CAB3XZEczgVTALA3_4hSBikJs=TXOhHHTHSLzmuU3MGot-hG+1g@mail.gmail.com>
	<1390997834.4143.7.camel@jlt4.sipsolutions.net>
	<1390998668.4143.8.camel@jlt4.sipsolutions.net>
	<CAB3XZEdmQzyYXYNh7=myKxDrqKCpZ+399a5QdvZcw8CrNd+Lwg@mail.gmail.com>
	<1391422193.4488.2.camel@jlt4.sipsolutions.net>
Date: Mon, 3 Feb 2014 12:43:59 +0200
Message-ID: <CAB3XZEdLip=kyZaG271nG+VEvwW1RqgOowaGH8ayZgFLdjFS9A@mail.gmail.com> (sfid-20140203_114402_586807_314F10ED)
Subject: Re: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute confusion
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 3, 2014 at 12:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2014-02-02 at 10:04 +0200, Eliad Peller wrote:
>
>> i referred to this:
>>
>>  * @match_sets: sets of parameters to be matched for a scan result
>>  * entry to be considered valid and to be passed to the host
>>  * (others are filtered out).
>>  * If ommited, all results are passed.
>>
>> it should probably mention the empty-ssid case as well.
>
> Well, hmm, that part seems fine, maybe the documentation for struct
> cfg80211_match_set should say that the SSID can be blank/zero length.
>
thanks.
the new patch looks good to me.

Eliad.

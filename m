Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:43145 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaBBIEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 03:04:12 -0500
Received: by mail-ig0-f178.google.com with SMTP id uq10so2324647igb.5
        for <linux-wireless@vger.kernel.org>; Sun, 02 Feb 2014 00:04:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390998668.4143.8.camel@jlt4.sipsolutions.net>
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEc94pTAMXWPYeWhu7o_YLEnD1_9O035-+YXYiR0Uij28w@mail.gmail.com>
	<1390810765.4251.0.camel@jlt4.sipsolutions.net>
	<CAB3XZEczgVTALA3_4hSBikJs=TXOhHHTHSLzmuU3MGot-hG+1g@mail.gmail.com>
	<1390997834.4143.7.camel@jlt4.sipsolutions.net>
	<1390998668.4143.8.camel@jlt4.sipsolutions.net>
Date: Sun, 2 Feb 2014 10:04:12 +0200
Message-ID: <CAB3XZEdmQzyYXYNh7=myKxDrqKCpZ+399a5QdvZcw8CrNd+Lwg@mail.gmail.com> (sfid-20140202_090437_472463_B8F4DD64)
Subject: Re: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute confusion
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 29, 2014 at 2:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-29 at 13:17 +0100, Johannes Berg wrote:
>> On Mon, 2014-01-27 at 11:37 +0200, Eliad Peller wrote:
>>
>> > > I don't think that's true? I looked at the drivers that use this and
>> > > they all skip empty SSIDs, except the one that I fixed.
>> > >
>> > ok. so at least fix the documentation? :)
>>
>> Umm, ok :)
>
> Wait .. not sure what documentation you're looking at?
>
i referred to this:

 * @match_sets: sets of parameters to be matched for a scan result
 * entry to be considered valid and to be passed to the host
 * (others are filtered out).
 * If ommited, all results are passed.

it should probably mention the empty-ssid case as well.

Eliad.

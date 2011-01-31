Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34856 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab1AaUQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 15:16:18 -0500
Received: by gyb11 with SMTP id 11so2147419gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 12:16:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296504395.3069.651.camel@pimenta>
References: <1296472589-26401-1-git-send-email-arik@wizery.com>
 <1296472589-26401-7-git-send-email-arik@wizery.com> <1296473043.3812.10.camel@jlt3.sipsolutions.net>
 <AANLkTin9vOQJqDJezzBMjjRyGNDYGEwOwgT_aFk2NBYD@mail.gmail.com>
 <1296475910.3812.27.camel@jlt3.sipsolutions.net> <1296504395.3069.651.camel@pimenta>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 31 Jan 2011 22:16:02 +0200
Message-ID: <AANLkTimCZOUA75hwHMLgArMOmy0BW_VRmd-CfCNKQdp-@mail.gmail.com>
Subject: Re: [PATCH v2 06/10] mac80211: add HW flag for disabling auto link-PS
 in AP mode
To: Luciano Coelho <coelho@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 22:06, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2011-01-31 at 13:11 +0100, Johannes Berg wrote:
>> On Mon, 2011-01-31 at 13:49 +0200, Arik Nemtsov wrote:
>> > On Mon, Jan 31, 2011 at 13:24, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > > It'd be nicer if you could separate out mac80211 patches, but then
>> Luca
>> > > needs to hold off merging until John picked up the mac80211 patch.
>> >
>> > Yea that would complicate matters a bit. Does the ordering of the
>> > patches bother you?
>>
>> It just makes it more complicated for me to pick out the right thing
>> --
>> I almost missed that there was a mac80211 patch in this huge series.
>
> Yes, I totally agree with Johannes.  I prefer that
> mac80211/cfg80211/whatever_other_stuff be sent as separate series, so
> that there's not confusions about who applies what.  If the patches are
> in the same series, I always need to ask John to either take them all or
> not.
>
> The ideal is if you send mac80211 patches separated from wl12xx and
> mention the dependency on the wl12xx series, so I'm aware and wait for
> John's integration before taking the wl12xx stuff in.

Sure thing. I'll separate the patches.

Arik

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:45801 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1HIGf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 02:35:26 -0400
Received: by iye16 with SMTP id 16so10445247iye.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 23:35:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312819173.4372.39.camel@jlt3.sipsolutions.net>
References: <1312811422-24911-1-git-send-email-eliad@wizery.com>
	<1312819145.4372.38.camel@jlt3.sipsolutions.net>
	<1312819173.4372.39.camel@jlt3.sipsolutions.net>
Date: Tue, 9 Aug 2011 09:35:25 +0300
Message-ID: <CAB3XZEfPXa+Mz8V7KxedK3pKq8Q9_S4GMcAHTf1if5N3T_kBEA@mail.gmail.com> (sfid-20110809_083531_597069_A3325C3E)
Subject: Re: [PATCH] mac80211: clear sta.drv_priv on reconfiguration
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 8, 2011 at 6:59 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-08-08 at 17:59 +0200, Johannes Berg wrote:
>> On Mon, 2011-08-08 at 16:50 +0300, Eliad Peller wrote:
>> > drivers might assume sta.drv_priv is clear while
>> > the sta is added, so clear it on reconfinguration.
>>
>>
>> Seems fine,
>> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> Does this address a current bug? If so, Cc stable?
>
not any current bug that i'm aware of.
i encountered it during the development of another patch.

Eliad.

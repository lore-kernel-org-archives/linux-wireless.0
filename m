Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36229 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbbJAAJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 20:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <1443639852.1859.25.camel@sipsolutions.net>
References: <CA+5PVA4yaLG2NtJ_Bg5-BQzR-Wa5ABxPb-cLxF7bjSsf-P1_5Q@mail.gmail.com>
	<1443637937.1859.19.camel@sipsolutions.net>
	<1443639852.1859.25.camel@sipsolutions.net>
Date: Wed, 30 Sep 2015 20:09:48 -0400
Message-ID: <CA+5PVA5L2LwwbJmoxwkYtJ=PYc9Q5g4KpqwmA0urxX8CRe=L+g@mail.gmail.com> (sfid-20151001_021059_980846_BB9E9476)
Subject: Re: Rate limiting AP bandwidth change messages in ieee80211_config_bw?
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2015 at 3:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>>
>> I'm not sure ratelimiting it would even work - it's not *that* high
>> frequency? Not really sure though.
>>
>> I think we can do either, it's not such a terribly important message as
>> far as I can tell.
>>
>
> Seems like Emmanuel would like to see the message stay in some form -

For what purpose?  Or rather, when a user sees this in their dmesg,
what are they supposed to do about it?

> perhaps we should try rate limiting it then? Could you check if that
> actually works?

I'll think on it, sure.  I was hoping sdata_dbg would be sufficient
because it's much easier, but if there's value in the message I can
look at limiting it in some fashion.

josh

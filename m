Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:60285 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaAPJ2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 04:28:07 -0500
Received: by mail-bk0-f42.google.com with SMTP id my12so1083874bkb.29
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 01:28:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389792139.4338.6.camel@jlt4.sipsolutions.net>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	<1389787494-7361-10-git-send-email-michal.kazior@tieto.com>
	<1389792139.4338.6.camel@jlt4.sipsolutions.net>
Date: Thu, 16 Jan 2014 10:28:04 +0100
Message-ID: <CA+BoTQ=UJNLD3dmzD4PDK1exSJFeWTdpkAHc2YvVbktugw_AyQ@mail.gmail.com> (sfid-20140116_102811_302012_160F79A8)
Subject: Re: [RFC 9/9] mac80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 January 2014 14:22, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
>> This implements a fairly simple multi-interface
>> CSA. It doesn't support multiple channel
>> contexts so it doesn't support multi-channel.
>
> It seems that this also means that somewhere you need to advertise the
> multi-switch feature. I guess you need that anyway, but this makes it
> obvious.

I don't really understand. Do we really need it? You want to advertise
it just to cfg80211 or all the way up to userspace?


Michał

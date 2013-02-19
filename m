Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:62276 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3BSSB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 13:01:57 -0500
Received: by mail-bk0-f49.google.com with SMTP id w11so3205110bku.8
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 10:01:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361197194.8555.17.camel@jlt4.sipsolutions.net>
References: <1361042551-15598-1-git-send-email-thomas@cozybit.com> <1361197194.8555.17.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 19 Feb 2013 10:01:33 -0800
Message-ID: <CAG6hwVOnRhFAVgL9LrdFdaAuoB0zYZxSi+t4iSvwZ_c31h4Saw@mail.gmail.com> (sfid-20130219_190213_331462_CEDD5FC7)
Subject: Re: [RFC] mac80211: make CONFIG_MAC80211_MESH=y default
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 18, 2013 at 6:19 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2013-02-16 at 11:22 -0800, Thomas Pedersen wrote:
>> Increases mac80211 memory use by about 95K.
>>
>> At least Ubuntu, Debian, and Arch Linux already enable
>> this in their default kernels.
>
> *shrug*
>
> I guess I don't really see a problem with this, although only a small
> subset of drivers really supports it. Anyone really wanting to build for
> a small system will probably turn it off anyway.
>
> OTOH, if distros enable it, I also don't see much point in changing
> it ;-)

Heh, good point. I guess this is an attempt to elevate mesh from the
status of "2nd-class citizen" into the realm of "good enough to
default =y" :)

If it's all the same to you I'll go ahead and submit this as a PATCH then.

-- 
Thomas

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61038 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2KQXjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 18:39:09 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so682096wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Nov 2012 15:39:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353142745.9543.9.camel@jlt4.sipsolutions.net>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
 <1353134886-13256-4-git-send-email-marco.porsch@etit.tu-chemnitz.de> <1353142745.9543.9.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Sat, 17 Nov 2012 15:38:47 -0800
Message-ID: <CAG6hwVO1j6zLPHziiZB5bzJDw4uz5Q5tXuPoz33zFkN-wW8eBg@mail.gmail.com> (sfid-20121118_003913_362944_968804BF)
Subject: Re: [RFC 03/14] {cfg,nl}80211: set and get default mesh power mode
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	javier@cozybit.com, linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 17, 2012 at 12:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-11-16 at 22:47 -0800, Marco Porsch wrote:
>> Possibilities of setting and getting mesh default power mode are
>> added.
>
> ditto.
>
>
>> + * @NL80211_MESHCONF_POWER_MODE: default link-specific power save
>> mode
>
> please describe the type of the attribute (u8)
>
>
>> +       FILL_IN_MESH_PARAM_IF_SET(tb, cfg, power_mode,
>> +                                 mask, NL80211_MESHCONF_POWER_MODE,
>> +                                 nla_get_u8);
>
> Huh, ok, how did this FILL_IN_MESH_PARAM thing ever get here ... sad I
> missed that, all of those are *completely* missing range checks.
>
> Please add them here, and somebody should also follow up with a patch to
> fix them on the other attributes.

Noted.

Thomas

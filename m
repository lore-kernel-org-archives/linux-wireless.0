Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41081 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1EJVzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 17:55:10 -0400
Received: by iyb14 with SMTP id 14so5555115iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 14:55:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152413.98046.qm@web161612.mail.bf1.yahoo.com>
References: <BANLkTimp10vXTRkC7mBgDX97aiE+Eo_seg@mail.gmail.com> <152413.98046.qm@web161612.mail.bf1.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 May 2011 14:54:50 -0700
Message-ID: <BANLkTins6p1f6kPN2st4pC49azs9get6Sw@mail.gmail.com> (sfid-20110510_235520_532878_338A944A)
Subject: Re: [PATCH 3/3] compat-wireless: enable RT33XX and RT53XX support.
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2011 at 8:23 AM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
>
>> The following config options are all marked as unstable
>> (they depend
>> on EXPERIMENTAL)
>>  RT2800PCI_RT35XX
>>  RT2800PCI_RT53XX
>>  RT2800USB_RT35XX
>>  RT2800USB_RT53XX
>
> So this basically means everything above 33+ is experimental at this point. RT33xx should only be enabled now, per my original patch.
>
> Walter
> -------
>
> // Side note to Luis,
> compat-wireless tar balls aren't being uploaded to orbit and kernel, despite the successful emails from the cron bot. Last uploaded CW archive was 5 days ago, can you look that up? //

Hauke -- Applied your 2 patches. I did not apply this last one though
as it seems it requires some modifications. Walter, the releases
likely stopped as ./scripts/admin-update.sh was failing, after the new
patches it should pick up.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49863 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab1FVRPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 13:15:55 -0400
Received: by iyb12 with SMTP id 12so839197iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 10:15:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110622T103452-665@post.gmane.org>
References: <1308704862-5684-1-git-send-email-lrodriguez@atheros.com> <loom.20110622T103452-665@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Jun 2011 10:15:33 -0700
Message-ID: <BANLkTimr-37bhou=zcw+ePiRvofv7EFBZA@mail.gmail.com> (sfid-20110622_191558_925373_B1A9CA7F)
Subject: Re: [RFC v2] hostapd: add Automatic Channel Selection (ACS) support
To: jpo <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 1:39 AM, jpo <pommnitz@yahoo.com> wrote:
> Luis R. Rodriguez <lrodriguez@...> writes:
>
>>
>> This adds Automatic Channel Selection (ACS) support to hostapd
>> using the Survery based ACS algorithm [1].
>
> Will there be a command line tool for IBSS? I imagine something like
> iw dev wlan0 ibss join "TheNetwork" $(acstool dev wlan0)
> or as part of iw
> iw dev wlan0 ibss join "TheNetwork" acs

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/acs.git

So you can use this, we can also throw into iw, up to Johannes, might
come in handy so it can also be used with mesh and stuff, we can also
just keep it separate.

  Luis

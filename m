Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:44222 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbZHMUEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:04:40 -0400
Received: by yxe5 with SMTP id 5so1296989yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 13:04:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250193283.21250.10.camel@johannes.local>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
	<1250191909-21682-11-git-send-email-lrodriguez@atheros.com>
	<1250192346.21250.6.camel@johannes.local> <43e72e890908131246t44fe8c3eya3d3894810aeea7f@mail.gmail.com>
	<1250193283.21250.10.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 Aug 2009 13:04:21 -0700
Message-ID: <43e72e890908131304h398ea1cche0f844b7f10a12dd@mail.gmail.com>
Subject: Re: [PATCH 10/20] wireless: group Broadcom wireless drivers on
	kconfig
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 12:54 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-08-13 at 12:46 -0700, Luis R. Rodriguez wrote:
>
>> > Also, I don't think rndis wlan is always broadcom, and in an case it's
>> > almost never marked as such.
>>
>> From the rndis_wlan kconfig:
>>
>>           "All of these devices are based on Broadcom 4320 chip which is the
>>           only wireless RNDIS chip known to date."
>
> Yeah, but it's more of a spec. Anyway I guess that doesn't matter much.

Oh ok, I didn't get that from the kconfig entry, we can fix that though.

  Luis

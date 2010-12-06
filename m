Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57972 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab0LFWC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 17:02:26 -0500
Received: by iwn9 with SMTP id 9so707313iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 14:02:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101206215958.GJ21442@tux>
References: <1291669987-23434-1-git-send-email-greearb@candelatech.com> <20101206215958.GJ21442@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 6 Dec 2010 14:02:05 -0800
Message-ID: <AANLkTikDW6d+rTagHzXD_nFA1K7L1sVxEcFGXtrKhHXs@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Make DMA warning in ath_stoprecv WARN_ON_ONCE.
To: "greearb@gmail.com" <greearb@gmail.com>
Cc: "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 1:59 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Dec 06, 2010 at 01:13:07PM -0800, greearb@gmail.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This decreases spammage in the log.  A single line message
>> will still be printed, so users can be aware that problem
>> exists.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

You forgot to address linville, and no need to send to ath9k-devel if
you already know the patch is good.

  Luis

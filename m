Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:62625 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbZHQRBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:01:00 -0400
Received: by yxe5 with SMTP id 5so3760453yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 10:01:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250283993.4411.1.camel@johannes.local>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	<1250281559-13041-33-git-send-email-lrodriguez@atheros.com>
	<1250283993.4411.1.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 17 Aug 2009 10:00:40 -0700
Message-ID: <43e72e890908171000r52f59cb6tbfef751324bf9968@mail.gmail.com>
Subject: Re: [PATCH v4 32/34] wireless: make mac80211 select cfg80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 2:06 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-08-14 at 16:25 -0400, Luis R. Rodriguez wrote:
>> We can now remove that comment about mac80211 requiring
>> cfg80211 and do that for the user.
>
> "now"? What changed to make this possible?
>
> NAK this change, because with it, it's possible to select
> mac80211 = Y
> -> cfg80211 = Y
> while rfkill = M
>
> which will break the kernel build.

I'm able to do this with current kconfig, does this need to be fixed?

  Luis

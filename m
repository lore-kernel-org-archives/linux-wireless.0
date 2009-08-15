Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54096 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZHOMMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 08:12:39 -0400
Received: by fxm11 with SMTP id 11so1572794fxm.39
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2009 05:12:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250283993.4411.1.camel@johannes.local>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	<1250281559-13041-33-git-send-email-lrodriguez@atheros.com>
	<1250283993.4411.1.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 15 Aug 2009 14:12:19 +0200
Message-ID: <69e28c910908150512o68c51875j2dc644e9c5ce3359@mail.gmail.com>
Subject: Re: [PATCH v4 32/34] wireless: make mac80211 select cfg80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 11:06 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
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
>
> johannes
>

Why not make cfg80211 select rfkill?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

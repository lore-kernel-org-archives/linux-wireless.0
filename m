Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:38206 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0ANRZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 12:25:05 -0500
Received: by pzk1 with SMTP id 1so8470903pzk.33
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 09:25:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263489795-3515-1-git-send-email-lrodriguez@atheros.com>
References: <1263489795-3515-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 14 Jan 2010 09:24:44 -0800
Message-ID: <43e72e891001140924s193c9e05gecb571318bdef7e0@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Ingore country IEs with a zero set of number of
	channels
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 14, 2010 at 9:23 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Previous to this and the last patch, titled,
>
> "cfg80211: Fix 2 GHz subband calculation for country IEs"
>
> we would end up treating these IEs as single channel units. These are in
> fact just bogus IE triplets so ignore the entire IE if these are found.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Just noticed this needs to be done in a second place too, will resend with that.

  Luis

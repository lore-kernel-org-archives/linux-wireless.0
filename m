Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39419 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872Ab0GNShF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 14:37:05 -0400
Received: by pzk26 with SMTP id 26so18708pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jul 2010 11:37:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279070845-29442-2-git-send-email-lrodriguez@atheros.com>
References: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
	<1279070845-29442-2-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 14 Jul 2010 11:36:44 -0700
Message-ID: <AANLkTimU48KppNBqaSyYF0gSu_ddplu0AOTaypO0wEZc@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: implement mac80211 flush op
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 13, 2010 at 6:27 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This implements the mac80211 flush callback to let mac80211
> flush the hardware queues when it deems appropriate.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

John, sorry, please hold off on this one, I need to do some more tests.

  Luis

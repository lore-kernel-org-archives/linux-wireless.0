Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49712 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0G0UQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 16:16:07 -0400
Received: by pwi5 with SMTP id 5so624262pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 13:16:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280257471-9126-1-git-send-email-lrodriguez@atheros.com>
References: <1280257471-9126-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 27 Jul 2010 13:15:45 -0700
Message-ID: <AANLkTim_QE_br8CA=Pw=hGU2uZZxBoEpi3vPuEPAzZmo@mail.gmail.com>
Subject: Re: [PATCH] Revert "mac80211: fix sw scan bracketing"
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 12:04 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> The spurious warnings
> will come up still but since they are wrapped under KERN_DEBUG
> and this will be addressed in the next kernel release we leave
> then in place.

Johannes wants these to go away so I'll resend in a new series
removing these first.

  Luis

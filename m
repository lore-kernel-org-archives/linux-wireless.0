Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60494 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932952AbcKJNzy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 08:55:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Lazar\, Alexei Avshalom" <ailizaro@codeaurora.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: cfg80211: add set/get link loss profile
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
Date: Thu, 10 Nov 2016 15:55:49 +0200
In-Reply-To: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org> (Alexei
        Avshalom Lazar's message of "Thu, 10 Nov 2016 13:33:53 +0200")
Message-ID: <8737izqw0q.fsf@purkki.adurom.net> (sfid-20161110_145558_908594_FCC45439)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Lazar, Alexei Avshalom" <ailizaro@codeaurora.org> writes:

>>From b739abb6f29dc43a86b8b2b60e893b4441f8aa1f Mon Sep 17 00:00:00 2001
> From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
> Date: Sun, 6 Nov 2016 16:21:20 +0200
> Subject: [PATCH] cfg80211: add set/get link loss profile
>
> Introduce NL80211_CMD_SET_LINK_LOSS_PROFILE and
> NL80211_CMD_GET_LINK_LOSS_PROFILE as it required by the user space
> to configure the link loss profile.
> The link loss profile represents the priority of maintaining link up
> in different link quality environments.
> Three types of behavior for link loss defined:
> LINK_LOSS_PROFILE_RELAXED: prefer maintaining link up even in poor
> link quality environment.
> LINK_LOSS_PROFILE_DEFAULT: The default behavior for maintaining link
> up vs link quality.
> LINK_LOSS_PROFILE_AGGRESSIVE: prefer losing link up in poor link
> quality environment.
> New cfg80211 API also been added, set/get_link_loss_profile.
>
> Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

What does the term "link" mean in this context? A connection to the AP
or something else? The documentation doesn't give me any detailed
information nor any examples and lefts me guessing what this is supposed
to do.

-- 
Kalle Valo

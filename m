Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51983 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab1KNUjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 15:39:22 -0500
Received: by vws1 with SMTP id 1so5468850vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 12:39:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321289887.10264.17.camel@jlt3.sipsolutions.net>
References: <1321287289.10264.16.camel@jlt3.sipsolutions.net> <1321289887.10264.17.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 14 Nov 2011 12:39:00 -0800
Message-ID: <CAB=NE6Vvp7wqr0sW=LMVxFzETgSPggDGE_zvXzpEBe2hr7aA2g@mail.gmail.com> (sfid-20111114_213925_121093_6449F2E4)
Subject: Re: [PATCH 2/2] compat: add skb_complete_wifi_ack & feature flag
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 14, 2011 at 8:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This just needs to be empty -- older kernels don't
> have the necessary infrastructure for this.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and pushed, thanks!

  Luis

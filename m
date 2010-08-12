Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64575 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab0HLHZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 03:25:41 -0400
Received: by qyk5 with SMTP id 5so1235538qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Aug 2010 00:25:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1281597845-6342-1-git-send-email-vnatarajan@atheros.com>
References: <1281597845-6342-1-git-send-email-vnatarajan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 12 Aug 2010 00:25:20 -0700
Message-ID: <AANLkTi=Mr-vf+4yf5Zribnpu8qLFCz21kF3bi4f4tBZ-@mail.gmail.com>
Subject: Re: [PATCH] ath9k_htc: Fix disconnect issue in HT40 mode.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 12, 2010 at 12:24 AM, Vivek Natarajan
<vnatarajan@atheros.com> wrote:
> Set WLAN_RC_40_FLAG only if the current channel configuration
> is HT40 enabled.

What does this fix? Is this a stable fix, if so why?

  Luis

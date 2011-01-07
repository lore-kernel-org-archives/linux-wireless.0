Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58189 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1AGA5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 19:57:32 -0500
Received: by iyi12 with SMTP id 12so15372119iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 16:57:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Jan 2011 16:57:11 -0800
Message-ID: <AANLkTin2YS4akjJpAhagqesoNO-5D=ngbMJLOqS8-yQu@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Decrease skb size to fit into
 one page.
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 4:46 PM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Patch is from Eric Dumazet, as described here:
> https://patchwork.kernel.org/patch/104271/
>
> Reported-by: Michael Guntsche <mike@it-loops.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Did he SOB it?

  Luis

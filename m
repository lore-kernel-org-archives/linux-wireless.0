Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0JNTRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 15:17:08 -0400
Received: by iwn35 with SMTP id 35so327421iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 12:17:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287083601-1293-1-git-send-email-greearb@candelatech.com>
References: <1287083601-1293-1-git-send-email-greearb@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Oct 2010 12:16:47 -0700
Message-ID: <AANLkTim5HNbOc5a7M--5f-A+PR3wPRmVGwbPm+QMSfz=@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Remove bf_dmacontext, null out stale pointers.
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 12:13 PM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> The bf_dmacontext seems to be totally useless and duplicated
> by bf_buf_addr.  Remove it entirely, use bf_buf_addr in its
> place.
>
> Also null out bf_buf_addr and bf_mpdu pointers when resources
> they are pointing to are no longer owned by the buffer object.

Please split these two changes up into two separate patches.

  Luis

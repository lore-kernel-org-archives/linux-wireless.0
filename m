Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36778 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0LFWAB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 17:00:01 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 13:59:46 -0800
Date: Mon, 6 Dec 2010 13:59:58 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "greearb@gmail.com" <greearb@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Make DMA warning in ath_stoprecv
 WARN_ON_ONCE.
Message-ID: <20101206215958.GJ21442@tux>
References: <1291669987-23434-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1291669987-23434-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 06, 2010 at 01:13:07PM -0800, greearb@gmail.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This decreases spammage in the log.  A single line message
> will still be printed, so users can be aware that problem
> exists.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis

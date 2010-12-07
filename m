Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33270 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0LGFV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 00:21:28 -0500
Received: by qwa26 with SMTP id 26so119167qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 21:21:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291698829-22765-1-git-send-email-greearb@candelatech.com>
References: <1291698829-22765-1-git-send-email-greearb@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Dec 2010 21:21:07 -0800
Message-ID: <AANLkTik20SkL0Y5gK_ysYpW46gvb73m4h3SDcGb+d_LA@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Check for NULL sta in ath_tx_start
To: greearb@gmail.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 9:13 PM,  <greearb@gmail.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> It can be NULL according to docs, and logging showed it
> to be NULL in practice.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Does this fix an oops? If so can you explain and provide the trace and
resubmit and cc stable in the commit log?

  Luis

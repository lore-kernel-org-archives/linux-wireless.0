Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40544 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1BDHh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 02:37:58 -0500
Received: by iwn9 with SMTP id 9so1889291iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 23:37:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296800640-6381-2-git-send-email-vnatarajan@atheros.com>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com> <1296800640-6381-2-git-send-email-vnatarajan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Feb 2011 23:37:38 -0800
Message-ID: <AANLkTikqBvB6+bwKRPFb+oSstzbR9K=bdmjK-D76D23Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: Fix a race on enabling power save.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 3, 2011 at 10:24 PM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
> There is a race of queuing a data frame before the tx completion
> of nullfunc frame for enabling power save. This has caused a power
> save state mismatch between the station and the AP. This patch
> addresses this issue.
>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Not stable fix? What't the effect of not having this patch? The
description could use some love to explain better what is observed in
terms of metrics or loss.

  Luis

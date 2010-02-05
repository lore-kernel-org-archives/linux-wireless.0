Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:59373 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933493Ab0BEAPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 19:15:07 -0500
Received: by pzk28 with SMTP id 28so3235584pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 16:15:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265317566-15372-1-git-send-email-benoit.papillault@free.fr>
References: <1265317566-15372-1-git-send-email-benoit.papillault@free.fr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 4 Feb 2010 16:14:46 -0800
Message-ID: <43e72e891002041614o3736d56axd41054c295703a76@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix rate table choice
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 4, 2010 at 1:06 PM, Benoit Papillault
<benoit.papillault@free.fr> wrote:
> ath9k rate control choose the rate table based on the current channel
> (if it is ht40 or not). However, it happens that at this stage, the
> channel is still ht20 even if the peer sta capabilities would later
> allow ht40. So let's use peer sta capabilities directly.

Can you clarify this commit log entry a little more, I don't think I
get it yet. Also, is this a stable fix? If so, please Cc:
stable@kernel.org on the commit log entry.

  Luis

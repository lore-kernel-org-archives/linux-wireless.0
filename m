Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34818 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbEAMqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2015 08:46:30 -0400
Received: by igbyr2 with SMTP id yr2so37908780igb.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 May 2015 05:46:29 -0700 (PDT)
Date: Fri, 1 May 2015 08:46:22 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com
Subject: Re: [PATCH 00/11] ath9k: Spectral scan updates
Message-ID: <20150501124622.GD14037@localhost> (sfid-20150501_144638_517979_1AF1FA0B)
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 29, 2015 at 11:51:11PM +0000, Nick Kossifidis wrote:
> Now we need someone to write a nice real-time GUI for that...

This fails on the "nice" front, but as a starting point for something
"real-time" I hacked up this thing a while ago (most of the existing
tools I found for this were offline post-processors):

https://github.com/bcopeland/speccy

The visualization is basically garbage so complete rewrites welcome :)

I'll give your patches on my ath9k_htc device.

-- 
Bob Copeland %% http://bobcopeland.com/

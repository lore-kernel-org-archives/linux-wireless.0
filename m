Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:45828 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932138Ab1BWNxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 08:53:50 -0500
Received: by mail-wy0-f169.google.com with SMTP id 11so3158976wyi.28
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 05:53:49 -0800 (PST)
Subject: Re: [PATCH] wl12xx: avoid blocking while holding rcu lock on bss
 info change
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1297545860-26313-1-git-send-email-arik@wizery.com>
References: <1297545860-26313-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:53:45 +0200
Message-ID: <1298469225.2104.23.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-02-12 at 23:24 +0200, Arik Nemtsov wrote:
> Some blocking functions were called while holding the rcu lock for
> accessing STA information. This can lead to a deadlock.
> 
> Save the required info beforehand and release the rcu without
> blocking.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> --- 

Applied, thank you!

-- 
Cheers,
Luca.


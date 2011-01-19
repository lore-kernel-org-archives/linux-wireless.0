Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36290 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1ASLSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 06:18:20 -0500
Received: by qyj19 with SMTP id 19so488854qyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 03:18:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092108.19628.43971.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092108.19628.43971.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 06:17:46 -0500
Message-ID: <AANLkTinsDhH+bg8jm-S2qjrDSsbjrTEAp3Vdmvqd+1Wn@mail.gmail.com>
Subject: Re: [PATCH 7/8] ath5k: Remove unused sc->curmode
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 4:21 AM, Bruno Randolf <br1@einfach.org> wrote:
> sc->curmode is set but never used. Remove it and the helper function. Also the
> ath5k_rate_update which is refered to in the comment does not exist (any more?)
> so we don't need to setup the band in that place.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

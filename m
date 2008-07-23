Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:5564 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYGWMQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 08:16:36 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2367269rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 05:16:35 -0700 (PDT)
Message-ID: <b6c5339f0807230516g7594143aia1f7c796f49e2a72@mail.gmail.com> (sfid-20080723_141640_261782_426AE43B)
Date: Wed, 23 Jul 2008 08:16:35 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/3] Ath5k: fix beacon-update deadlock
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1216811855-9387-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216811855-9387-1-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 7:17 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Commit 9d139c810a2aa17365cc548d0cd2a189d8433c65 introduced
> AA deadlock -- ath5k_config_interface(); holds sc->lock
> and it calls ath5k_beacon_update(); which tries to grab the
> lock again.

I already posted a patch for this a few days ago, did it get picked up?

-- 
Bob Copeland %% www.bobcopeland.com

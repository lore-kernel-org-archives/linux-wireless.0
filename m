Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1114 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbZETUaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 16:30:39 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: Tobias Doerffel <tobias.doerffel@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ath5k: add support for radio LED
Date: Wed, 20 May 2009 16:29:42 -0400
Message-Id: <20090520202124.M71221@bobcopeland.com>
In-Reply-To: <200905202216.43996.tobias.doerffel@gmail.com>
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com> <200905202216.43996.tobias.doerffel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 May 2009 22:16:42 +0200, Tobias Doerffel wrote
> If there's interest, I'll  prepare a new patch which represents the
> current state.

I'm definitely interested in seeing rfkill gpio support getting in,
it's overdue.  So I say repost it and we can fasttrack that.  Digging
up your last patchset was already on my todo list.

As for patch 2/3 it might be a good idea to have support for
which-led-does-what encoded into the driver data anyway; other
people have asked for that and the "solution" of adding various
echos to sysfs LED trigger files is rather sad.  OTOH it could
eventually be a lot of data to carry around.

-- 
Bob Copeland %% www.bobcopeland.com


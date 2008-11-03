Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2502 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYKCCpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 21:45:23 -0500
Date: Sun, 2 Nov 2008 21:44:55 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	michael+ath5k@stapelberg.de, linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix detection of jumbo frames
Message-ID: <20081103024455.GA11462@hash.localnet> (sfid-20081103_034528_834593_B2A64269)
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com> <43e72e890811021300o6bef49b0i515d0f72974cef00@mail.gmail.com> <20081102215218.GA6203@hash.localnet> <43e72e890811021433q61fe925bt5817f9e1ab0ba581@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890811021433q61fe925bt5817f9e1ab0ba581@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 02, 2008 at 02:33:44PM -0800, Luis R. Rodriguez wrote:
> > Not sure I follow - these are incoming frames, which all had a status_0
> > of 0x1a40 (rs_more=0x1000 & length=0xa40).  So hw rate index was zero
> > on these for some reason, but in my testing the rate index of all other
> > packets was something reasonable, e.g. 0x27.
> 
> Interesting -- I will have to check on what this means.

Yup, it would be good to handle these properly.

-- 
Bob Copeland %% www.bobcopeland.com


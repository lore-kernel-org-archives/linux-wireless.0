Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1147 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZCWCcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 22:32:23 -0400
Date: Sun, 22 Mar 2009 22:31:52 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	linville@tuxdriver.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-kernel@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090323023152.GB5287@hash.localnet> (sfid-20090323_033238_967376_2C20363D)
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com> <1231338965-796-1-git-send-email-jirislaby@gmail.com> <200903152227.16676.s.L-H@gmx.de> <200903230146.02071.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200903230146.02071.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 01:45:58AM +0100, Stefan Lippers-Hollmann wrote:
>
> Post scriptum: I'm not able to trigger this trace with ath5k/ AR2425.

Okay, well just to be clear ath5k had the same issue (I posted a patch
a couple of weeks ago - I think it got lost and I need to repost it).  

But this is separate from the problem where the rate controller is 
choosing a bad rate index for TX in adhoc mode, that's still an unknown, 
unsolved problem.

-- 
Bob Copeland %% www.bobcopeland.com


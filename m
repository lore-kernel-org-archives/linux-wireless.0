Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3672 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZKANTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 08:19:08 -0500
Date: Sun, 1 Nov 2009 08:16:52 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
Subject: Re: ath5k AP issues
Message-ID: <20091101131652.GA30381@hash.localnet>
References: <200910291330.26172.mb@bu3sch.de> <200910291406.03422.mb@bu3sch.de> <200910291431.48388.mb@bu3sch.de> <20091031202156.GA29825@hash.localnet> <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 01, 2009 at 08:53:44AM +0200, Nick Kossifidis wrote:
> 2009/10/31 Bob Copeland <me@bobcopeland.com>:
> notice the AR5K_QCU_RDYTIMECFG_ENABLE. So it's probable that the queue
> starts on time and we miss sync because we wait an extra ready-time
> period.

Yeah, I know -- I turned it off before running tests.  I don't
think it ever ran the queue, or if it did it was very late.

-- 
Bob Copeland %% www.bobcopeland.com


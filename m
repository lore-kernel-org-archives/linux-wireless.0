Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4991 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZKCTah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 14:30:37 -0500
Date: Tue, 3 Nov 2009 14:27:35 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>,
	ath9k-devel@lists.ath9k.org
Subject: Re: ath5k AP issues
Message-ID: <20091103192735.GA11145@hash.localnet>
References: <200910291330.26172.mb@bu3sch.de> <200910291406.03422.mb@bu3sch.de> <200910291431.48388.mb@bu3sch.de> <20091031202156.GA29825@hash.localnet> <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com> <20091101131652.GA30381@hash.localnet> <40f31dec0911010541l650513fg31ffcadd12698f0@mail.gmail.com> <20091102194349.GA7709@hash.localnet> <40f31dec0911021336l45d185fewa5ce1ffb88f7db97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0911021336l45d185fewa5ce1ffb88f7db97@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02, 2009 at 11:36:22PM +0200, Nick Kossifidis wrote:
> Well let's enable them both :P
> 
> I still think that ready-time thing is evil, we should use a more accurate
> way.

I don't follow, you want to try both DBA and BCN_SENT to see what happens
(with/without ready-time)?

-- 
Bob Copeland %% www.bobcopeland.com


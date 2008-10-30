Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:59706 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYJ3AGy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 20:06:54 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	"Bob Copeland" <me@bobcopeland.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
References: <87wsfvt76q.fsf@denkblock.local>
	<40f31dec0810261533g3143bd9bue0f3eff88c6936e9@mail.gmail.com>
	<87r663t1ds.fsf@denkblock.local>
	<40f31dec0810271331n7f374562x77da8ae55b9032db@mail.gmail.com>
	<873aifsfc9.fsf@denkblock.local>
	<40f31dec0810290749u2c065d17g5788eb22cf508142@mail.gmail.com>
	<87wsfrqw2t.fsf@denkblock.local>
	<b6c5339f0810290828g2c600d5cm9f78df9d427f5c1f@mail.gmail.com>
	<40f31dec0810291051j605a281dg641d873bd0e3bbc1@mail.gmail.com>
	<87mygn2dd7.fsf@denkblock.local> <20081029233426.GF3485@tuxdriver.com>
Date: Thu, 30 Oct 2008 01:04:30 +0100
In-Reply-To: <20081029233426.GF3485@tuxdriver.com> (John W. Linville's message
	of "Wed, 29 Oct 2008 19:34:26 -0400")
Message-ID: <874p2v2bjl.fsf@denkblock.local> (sfid-20081030_010658_938867_2A28BCFD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ Resending due to a totally screwed header. Time to go to bed now. ]

"John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org> wrote:
> Well, I already merged v3...what is new here?

Yes, that's alright. The only difference is that I've replaced all the
ugly hex-numbers by the appropriate constants in ath5k/reg.h that have
been introduced in 2.6.28-rc1. So, it's really just a matter of style.

Regards,

Elias

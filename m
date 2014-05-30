Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61510 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaE3Vlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 17:41:35 -0400
Date: Fri, 30 May 2014 23:41:22 +0200
From: Stefano Brivio <stefano.brivio@gmx.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH] mac80211: remove PID rate control
Message-ID: <20140530234122.5f5e0650@vaiolo.localdomain> (sfid-20140530_234139_432994_F8672B9E)
In-Reply-To: <1401461248-29427-1-git-send-email-linville@tuxdriver.com>
References: <1401461248-29427-1-git-send-email-linville@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 30 May 2014 10:47:28 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> Minstrel has long since proven its worth.

Just a quick note: a while ago, somebody proposed
(http://lkml.iu.edu/hypermail/linux/kernel/1202.3/02307.html) a
enhanced version of this algorithm that would, according to the related
research and paper [1], outperform Minstrel in most cases. The patch
was not accepted as comments (mostly related to coding style, but not
only that) weren't addressed by the sender. I then never had the time
to seriously look into it. My understanding is that the amended
algorithm would spare some air time compared to Minstrel, and thus it
could provide marginally better performance.

So, maybe somebody is interested in looking into that. Otherwise, yes,
let's drop it.

[1] Wei Yin, Peizhao Hu, Jadwiga Indulska and Konstanty Bialkowski.
Performance of mac80211 rate control mechanisms. In Proceedings of MSWiM
2011, October 31-November 4, 2011 Miami Beach, FL, USA. Which used to be
available at http://www.itee.uq.edu.au/∼uqwyin/publications/MSWiM2011,
but was then removed. I can send the PDF if anybody wants it, it carries
no copyright or distribution terms whatsoever.


--
Cheers
Stefano

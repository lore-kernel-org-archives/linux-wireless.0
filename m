Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:42554 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752488Ab1LGKTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 05:19:30 -0500
To: Hagen Paul Pfeifer <hagen@jauu.net>
Subject: Re: [Bloat] Time in Queue, bufferbloat, and... our accidentally  interplanetary network
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Date: Wed, 07 Dec 2011 11:19:29 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	bloat-devel <bloat-devel@lists.bufferbloat.net>,
	<netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bloat <bloat@lists.bufferbloat.net>
In-Reply-To: <9dfc3c5eb811f2774b378fce0158b3e7@localhost>
References: <CAA93jw7kQYONQiAozatRmdRRJeK0GB9eNDWtRZ3AL+OVKn0OpA@mail.gmail.com>
 <1323082774.2670.40.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <9dfc3c5eb811f2774b378fce0158b3e7@localhost>
Message-ID: <11877422e38eade300dd1cdb9e423d47@localhost> (sfid-20111207_111938_273153_4997847B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 07 Dec 2011 11:15:38 +0100, Hagen Paul Pfeifer <hagen@jauu.net>

wrote:

 

> Question two: I submitted pfast_head_drop to drop more outdated data

> instead of new data. Back in time I thought TCP _may_ experience

benefits

> because more up-to-date SACK data packets are saved. Are there any other

> TCP advantages with head drop policy?



Small comment: pfast_head_drop was intended for UDP. E.g. OLSR messages,

regular GPS reporting and the like. TCP was not the focus at that time.



HGN



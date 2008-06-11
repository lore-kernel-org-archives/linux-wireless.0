Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:54625 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYFKM4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 08:56:17 -0400
Date: Wed, 11 Jun 2008 08:56:15 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	compat-masters@lists.madwifi.org,
	Tim Gardner <tim.gardner@canonical.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [compat-masters] Backported MQ requirement on 802.11n for older kernels
Message-ID: <20080611125615.GF17936@ruslug.rutgers.edu> (sfid-20080611_145620_398103_9001DE4F)
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com> <c85cb4470806090053l5b763a23j43bbf0c87f594b0d@mail.gmail.com> <1213001797.698.57.camel@johannes.berg> <43e72e890806090201q55bff8e3m694121ebd4befee6@mail.gmail.com> <43e72e890806090325y5a1aebadq68204695044f4b6f@mail.gmail.com> <1ba2fa240806101657w14599f30x67f58acbc7fe9e80@mail.gmail.com> <43e72e890806102132q1aaba42ehd76bdd30b8d4080a@mail.gmail.com> <43e72e890806102136jb8e695fla98a8594dde14396@mail.gmail.com> <43e72e890806110403nddfca7cn66b91a938919e1f0@mail.gmail.com> <1ba2fa240806110455u7547cde8gff1128b03ce800aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240806110455u7547cde8gff1128b03ce800aa@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 02:55:38PM +0300, Tomas Winkler wrote:
> We need both to be enabled NET_SCHED and MULTIQUEUE for both WME and
> HT.  Both features requires multiple queues and scheduling.
> Tomas;

Ah, I missed WME. OK, so its a compatibility issue then it seems.
Patch is next.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33329 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab2HUHuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 03:50:18 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mahesh Palivela <maheshp@posedge.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local>
	<20120816102211.GD17659@redhat.com> <502CF2D5.6020704@posedge.com>
	<20120817140657.GA1645@redhat.com> <502E85D9.5050301@posedge.com>
	<1345480718.4459.37.camel@jlt3.sipsolutions.net>
Date: Tue, 21 Aug 2012 10:50:13 +0300
In-Reply-To: <1345480718.4459.37.camel@jlt3.sipsolutions.net> (Johannes Berg's
	message of "Mon, 20 Aug 2012 18:38:38 +0200")
Message-ID: <87d32k7kga.fsf@purkki.adurom.net> (sfid-20120821_095021_970024_70970E8B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On the other hand, maybe for VHT we want to completely change channel
> specifications? Maybe it would be better to allow specifying the
> *global* center frequency of the entire channel, and the width, and the
> control channel offset instead of encoding everything into the single
> channel type value? I don't know.

What about the future? Will we see 320 MHz wide channels in 2020? :)

After following the discussion about this I'm starting to think that
what you propose above makes our life easier in the long run. I just
don't trust that using a single channel type value is scalable in the
long run.

-- 
Kalle Valo

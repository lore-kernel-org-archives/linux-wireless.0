Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.iliad.fr ([212.27.33.1]:44688 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbbHEOVn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 10:21:43 -0400
Date: Wed, 5 Aug 2015 16:21:40 +0200
From: Maxime Bizon <mbizon@freebox.fr>
To: Chor Teck Law <ctlaw@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
Message-ID: <20150805142140.GB36260@sakura.staff.proxad.net> (sfid-20150805_162146_295261_3865A962)
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <1436455659.36587.131.camel@sakura.staff.proxad.net>
 <87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
 <20150804220956.GA28583@sakura.staff.proxad.net>
 <1d5d24295c1c45ec856c908c60dab13b@SC-EXCH03.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1d5d24295c1c45ec856c908c60dab13b@SC-EXCH03.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wednesday 05 Aug 2015 à 08:39:28 (+0000), Chor Teck Law wrote:

> Last words, The mwl8k series had its history, since 2009 with the
> Topdog series (Beyond our scope to comment). The mwlwifi have been
> developed over past year or so for the Avastar AP chips, being

incorrect, mwl8k also support Avastar AP (88W8764)

one of the mwlwifi feedback was that the Kconfig description was
inaccurate, and because of overlap with mwifiex, everyone did scratch
their heads trying to describe what each driver actually supports.

feel free to correct me on that, but from the outside it looks like
there are multiple wifi teams at Marvell, each one working on its own
firmware/driver set, sometimes for the same chipset as the other
teams, and they don't talk to each other.

so anyway I'm in no position to NAK your driver submission since I'm
not a linux wireless maintainer, I just want them to be aware of what
they are merging.

-- 
Maxime

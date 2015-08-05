Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63883 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106AbbHEP32 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 11:29:28 -0400
From: Chor Teck Law <ctlaw@marvell.com>
To: Maxime Bizon <mbizon@freebox.fr>
CC: Kalle Valo <kvalo@codeaurora.org>, David Lin <dlin@marvell.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: RE: [PATCH v5] Add new mac80211 driver mwlwifi.
Date: Wed, 5 Aug 2015 15:29:21 +0000
Message-ID: <6c9965aa6a32418d9d68ccc3aa584c3a@SC-EXCH03.marvell.com> (sfid-20150805_172933_802661_EDB973CC)
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <1436455659.36587.131.camel@sakura.staff.proxad.net>
 <87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
 <20150804220956.GA28583@sakura.staff.proxad.net>
 <1d5d24295c1c45ec856c908c60dab13b@SC-EXCH03.marvell.com>
 <20150805142140.GB36260@sakura.staff.proxad.net>
In-Reply-To: <20150805142140.GB36260@sakura.staff.proxad.net>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: Maxime Bizon [mailto:mbizon@freebox.fr]
> Sent: Wednesday, August 05, 2015 7:22 AM
> 
> On Wednesday 05 Aug 2015 à 08:39:28 (+0000), Chor Teck Law wrote:
> 
> > Last words, The mwl8k series had its history, since 2009 with the
> > Topdog series (Beyond our scope to comment). The mwlwifi have been
> > developed over past year or so for the Avastar AP chips, being
> 
> incorrect, mwl8k also support Avastar AP (88W8764)
> 

OK, I had used a wrong word. The mwlwifi currently supports 88W8864 and 88W8897 as softmac/hostmac. 

> one of the mwlwifi feedback was that the Kconfig description was
> inaccurate, and because of overlap with mwifiex, everyone did scratch
> their heads trying to describe what each driver actually supports.
> 

The discussion was around choice of words to distinguish 88W8897. The difference with mwifiex (fullmac vs softmac) and has been explained. 


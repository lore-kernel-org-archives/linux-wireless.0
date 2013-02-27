Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:54815 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3B0TBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 14:01:06 -0500
Cc: Paul Stewart <pstew@google.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 27 Feb 2013 11:20:30 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
Message-ID: <20130227192030.GW12537@pogo> (sfid-20130227_200120_788185_C6345147)
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
 <20757.1753.863278.858198@gargle.gargle.HOWL>
 <511508A6.8020104@openwrt.org>
 <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
 <51152D9E.1040106@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51152D9E.1040106@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 08, 2013 at 05:53:50PM +0100, Felix Fietkau wrote:
> On 2013-02-08 5:38 PM, Paul Stewart wrote:
> > Could you share some of the test results?  I know with ChromeOS when
> > we switched to 3.4, the first thing that tipped us off to the fact
> > that we had inadvertently switch to minstrel was that our RvR
> > throughput values had dropped significantly.  Has anyone done an RvR
> > comparison between minstrel and the ath9k internal rate control
> > lately?
> Are you sure it was minstrel_ht, or could it also have been minstrel
> (the legacy version)? I don't have any recent RvR test results, however
> on every single link that I tested both rate control modules on (leaving
> everything else unchanged), minstrel_ht got slightly better results.
> Additionally, I occasionally get asked for help on debugging low
> throughput issues, and many of the people asking me have reported that
> simply switching to minstrel_ht fixed these issues in their tests.
> 
> I would also like to see some real RvR tests comparing both, preferably
> before this gets merged, which is why I sent it as RFC.

Paul, curious if you've run any tests?

  Luis

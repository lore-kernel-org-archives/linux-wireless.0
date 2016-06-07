Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39434 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbcFGOuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 10:50:10 -0400
Date: Tue, 7 Jun 2016 20:20:02 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: Add support for QCA9887
Message-ID: <20160607145002.GB11250@atheros-ThinkPad-T61> (sfid-20160607_165016_937517_38BD5C44)
References: <1568876.Six5hABE57@bentobox>
 <1505571.v1gM3hzMhG@bentobox>
 <87wpmf4qm5.fsf@kamboji.qca.qualcomm.com>
 <2262792.6VVL0Htyzj@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2262792.6VVL0Htyzj@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven,

On Mon, May 30, 2016 at 01:12:27PM +0200, Sven Eckelmann wrote:
> On Friday 27 May 2016 12:44:52 Valo, Kalle wrote:
> [...]
> > > But maybe I should add that the results with the original AP147 firmware also
> > > wasn't better.
> > 
> > That doesn't sound good. Maybe a calibration issue?
> 
> Maybe but I don't have a different card to compare it to.
> 
> [...]
> > I pushed a new firmware image firmware-5.bin_10.2.3.31.7-2 with those
> > enabled:
> > 
> > https://github.com/kvalo/ath10k-firmware/tree/master/QCA9887
> 
> Thanks for the updated firmware file. I have done some basic tests and seems
> to work fine. Bindiff also looks fine
>
[shafi] it would be helpful if you can share your basic test results (if its
possible to share). Have you tried to bring up the card in 5ghz (or) 2ghz.
Or both of them were tried ?

regards
shafi



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47171 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbbJHHsj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 03:48:39 -0400
Message-ID: <1444290511.2131.0.camel@sipsolutions.net> (sfid-20151008_094845_542702_BC0F3B40)
Subject: Re: [PATCH] Revert "mac80211: remove exposing 'mfp' to drivers"
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@codeaurora.org>, c_traja@qti.qualcomm.com,
	ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 08 Oct 2015 09:48:31 +0200
In-Reply-To: <56154DE5.4040300@codeaurora.org>
References: <1444194604-12637-1-git-send-email-c_traja@qti.qualcomm.com>
	 <56154DE5.4040300@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-07 at 09:52 -0700, Peter Oh wrote:
> On 10/06/2015 10:10 PM, c_traja@qti.qualcomm.com wrote:
> > From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> > 
> > This reverts commit 5c48f1201744233d4f235c7dd916d5196ed20716.
> > 
> > Some device drivers (ath10k) offload part of aggregation including
> > AddBA/DelBA
> > negotiations to firmware. In such scenario, the PMF
> Is it typo of MFP or abbreviation of something else?


Oh, it's just some acronym confusion...

MFP = management frame protection
PMF = protected management frames

(or so)

johannes

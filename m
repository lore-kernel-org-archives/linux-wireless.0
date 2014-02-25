Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaBYPHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 10:07:00 -0500
Message-ID: <1393340816.4170.6.camel@jlt4.sipsolutions.net> (sfid-20140225_160706_655338_91CB4B42)
Subject: Re: [PATCH v1 2/6] mac80211: move flag
 IEEE80211_TX_CTL_FIRST_FRAGMENT into info->control.flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Date: Tue, 25 Feb 2014 16:06:56 +0100
In-Reply-To: <E84199A1-4743-47E5-AD95-D86998FD8DEA@net.t-labs.tu-berlin.de>
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393164527-13800-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393244741.4190.10.camel@jlt4.sipsolutions.net>
	 <E84199A1-4743-47E5-AD95-D86998FD8DEA@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 15:13 +0100, Thomas Hühn wrote:

> > At least temporary flags don't suffer from the 'getting lost' problem as
> > in the first patch.
> > 
> > I'll also note that this flag is treated wrongly in software retry
> > scenarios anyway, but it won’t really matter I guess.
> 
> Do you mean the case when fragments after the first one get retransmitted by software ?

Yeah, something about those cases is fishy ... but it doesn't matter
much for your patch.

johannes


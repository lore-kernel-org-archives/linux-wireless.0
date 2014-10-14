Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55440 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaJNJRp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 05:17:45 -0400
Message-ID: <1413278229.2455.0.camel@jlt4.sipsolutions.net> (sfid-20141014_111749_820745_5B385120)
Subject: Re: [PATCH v2] mac80211: fix typo in starting baserate for
 rts_cts_rate_idx
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	stable@vger.kernel.org
Date: Tue, 14 Oct 2014 11:17:09 +0200
In-Reply-To: <1413203681-13846-1-git-send-email-karl.beldan@gmail.com> (sfid-20141013_143515_337532_1581B346)
References: <1413193692-30521-1-git-send-email-karl.beldan@gmail.com>
	 <1413203681-13846-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20141013_143515_337532_1581B346)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-13 at 14:34 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> It affects non-(V)HT rates and can lead to selecting an rts_cts rate
> that is not a basic rate or way superior to the reference rate (ATM
> rates[0] used for the 1st attempt of the protected frame data).

Applied.

johannes


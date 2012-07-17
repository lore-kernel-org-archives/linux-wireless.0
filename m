Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2GQKAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 06:00:06 -0400
Message-ID: <1342519201.18105.2.camel@jlt3.sipsolutions.net> (sfid-20120717_120010_714341_EC818960)
Subject: Re: [PATCH v2] cfg80211: support TX error rate CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Date: Tue, 17 Jul 2012 12:00:01 +0200
In-Reply-To: <1342135053-12045-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1342135053-12045-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 16:17 -0700, Thomas Pedersen wrote:
> Let the user configure serveral TX error conection quality monitoring
> parameters: % error rate, survey interval, and # of attempted packets.
> 
> On exceeding the TX failure rate over the given interval, the driver
> will send a CQM notify event with the actual TX failure rate and
> packets attempted.

Applied, thanks.

johannes


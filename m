Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32808 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966012AbaLLLHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 06:07:43 -0500
Message-ID: <1418382458.2470.11.camel@sipsolutions.net> (sfid-20141212_120746_941257_2E0389ED)
Subject: Re: [PATCH] iw: Fix calculation of maximum supported 802.11n data
 rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Date: Fri, 12 Dec 2014 12:07:38 +0100
In-Reply-To: <1418203400-6451-1-git-send-email-hrogge@gmail.com> (sfid-20141210_102330_542659_B0D38BCA)
References: <1418203400-6451-1-git-send-email-hrogge@gmail.com>
	 (sfid-20141210_102330_542659_B0D38BCA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-10 at 10:23 +0100, Henning Rogge wrote:
> Fix typo in calculation, binary AND combination of low byte
> and high byte is always zero.

Obviously - applied, thanks.

johannes


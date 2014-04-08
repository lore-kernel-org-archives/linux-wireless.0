Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbaDHI4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 04:56:38 -0400
Message-ID: <1396947132.5936.5.camel@jlt4.sipsolutions.net> (sfid-20140408_105703_432670_6D3C8000)
Subject: Re: [PATCH] mac80211: update last_tx_rate only for data frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1396411509-4660-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140402_060526_703161_9C59A790)
References: <1396411509-4660-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20140402_060526_703161_9C59A790)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Apr 2014 10:52:12 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-02 at 12:05 +0800, Chun-Yeow Yeoh wrote:
> Rate controller in firmware may also return the Tx Rate
> used for management frame that is usually sent as lowest
> Tx Rate (1Mbps in 2.4GHz). So update the last_tx_rate only
> if it is data frame.

I guess this makes some sense, although maybe the rate shouldn't be
reported then?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62571 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbYLKU4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 15:56:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 12:56:03 -0800
Date: Thu, 11 Dec 2008 04:56:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Henning Rogge <hrogge@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Patch v14] nl80211: Add signal strength and bandwith to
	nl80211station info
Message-ID: <20081211125619.GA6810@tesla> (sfid-20081211_215609_814347_1E4CE430)
References: <200812112135.02656.hrogge@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200812112135.02656.hrogge@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 11, 2008 at 12:34:38PM -0800, Henning Rogge wrote:
> This patch adds signal strength and transmission bitrate
> to the station_info of nl80211.
> 
> Signed-off-by: Henning Rogge <rogge@fgan.de>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Please resend without a PGP sign patches, please see:

http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches#Priortosendingpatches

  Luis

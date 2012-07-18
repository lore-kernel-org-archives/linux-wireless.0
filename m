Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2GRGtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 02:49:45 -0400
Message-ID: <1342594185.5310.3.camel@jlt3.sipsolutions.net> (sfid-20120718_084947_618060_D8FBE2CE)
Subject: Re: [PATCH v3] ath6kl: support TX error rate notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Wed, 18 Jul 2012 08:49:45 +0200
In-Reply-To: <1342579195-18521-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120718_044010_258914_265CE137)
References: <1342579195-18521-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 (sfid-20120718_044010_258914_265CE137)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-17 at 19:39 -0700, Thomas Pedersen wrote:
> The ath6kl firmware can monitor a connection and report when a certain
> TX failure threshold is crossed. Support this configuration and event
> reporting on compatible firmwares.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
> ---
> v2:
> 	endianness & formatting (Kalle)
> v3:
> 	report configured interval
> 
> Kalle,
> 
> Please cherry-pick "84f10708f73254878246772cead70a2eb6a123f2" from w-t HEAD to
> support this.

I don't think you should cherry-pick patches, it makes them show up in
the trees twice later.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58528 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbcEBVYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 17:24:45 -0400
Message-ID: <1462224282.5898.23.camel@sipsolutions.net> (sfid-20160502_232447_535010_7AEA79B0)
Subject: Re: [PATCH v2] mac80211:  add vht cap decode to debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Mon, 02 May 2016 23:24:42 +0200
In-Reply-To: <1462224198-24154-1-git-send-email-greearb@candelatech.com>
References: <1462224198-24154-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-05-02 at 14:23 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This makes it a lot easier to understand the capabilities used
> by the station:
> 
> VHT supported
> cap: 0x300819b2
> 		MAX-MPDU-11454
> 		RXLDPC
> 		SHORT-GI-80
> 		TXSTBC
> 		RXSTBC_1
> 		RXSTBC_3
> 		SU-BEAMFORMER-CAPABLE
> 		SU-BEAMFORMEE-CAPABLE
> 		BEAMFORMEE-STS: 0x0
> 		SOUNDING-DIMENSIONS: 0x0
> 		MU-BEAMFORMER-CAPABLE
> 		MPDU-LENGTH-EXPONENT: 0x0
> 		LINK-ADAPTATION-VHT-MRQ-MFB: 0x0
> 		RX-ANTENNA-PATTERN
> 		TX-ANTENNA-PATTERN
> RX MCS: fffe
> TX MCS: fffe
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> v2:  Fix 'RX' typo in the second antenna pattern.
> 
and my suggestion avoids that kind of problem too ;-)

johannes

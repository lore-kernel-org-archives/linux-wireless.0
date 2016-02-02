Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32784 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbcBBPJF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:09:05 -0500
Message-ID: <1454425741.2926.7.camel@sipsolutions.net> (sfid-20160202_160909_821108_CDA961D3)
Subject: Re: [PATCH v2] cfg80211: basic support for PBSS network type
From: Johannes Berg <johannes@sipsolutions.net>
To: Lior David <liord@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Dedy Lansky <dlansky@codeaurora.org>,
	Maya Erez <merez@codeaurora.org>,
	Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Date: Tue, 02 Feb 2016 16:09:01 +0100
In-Reply-To: <56A9D831.7070909@codeaurora.org>
References: <56961335.4040801@codeaurora.org>
	 <1453807346.2759.29.camel@sipsolutions.net>
	 <56A767E4.7090906@codeaurora.org>
	 <1453812869.2759.38.camel@sipsolutions.net>
	 <56A9D831.7070909@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-28 at 10:58 +0200, Lior David wrote:
> PBSS (Personal Basic Service Set) is a new BSS type for DMG
> networks. It is similar to infrastructure BSS, having an AP-like
> entity called PCP (PBSS Control Point), but it has few differences.
> PBSS support is mandatory for 11ad devices.
> 
> Add support for PBSS by introducing a new PBSS flag attribute.
> The PBSS flag is used in the START_AP command to request starting
> a PCP instead of an AP, and in the CONNECT command to request
> connecting to a PCP instead of an AP.
> 
Applied.

johannes

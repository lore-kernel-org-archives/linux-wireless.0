Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41026 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFLop (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 06:44:45 -0500
Message-ID: <1415274279.17015.2.camel@sipsolutions.net> (sfid-20141106_124448_655287_719CC28B)
Subject: Re: [PATCH v2] mac80211: Fix regression that triggers a kernel BUG
 with CCMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 06 Nov 2014 12:44:39 +0100
In-Reply-To: <1415271133-6588-1-git-send-email-ronald.wahl@raritan.com>
References: <1415271133-6588-1-git-send-email-ronald.wahl@raritan.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-06 at 11:52 +0100, Ronald Wahl wrote:
> Commit 7ec7c4a9a686c608315739ab6a2b0527a240883c (mac80211: port CCMP to
> cryptoapi's CCM driver) introduced a regression when decrypting empty
> packets (data_len == 0). This will lead to backtraces like:

Applied, thanks.

johannes


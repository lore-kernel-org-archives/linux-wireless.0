Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr6.hinet.net ([168.95.4.106]:65076 "EHLO msr6.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab1FUHUz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 03:20:55 -0400
Date: Tue, 21 Jun 2011 13:43:10 +0800
From: Ali Bahar <ali@internetdog.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Lamorce <FLamorce@CalAmp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: nl80211: set_key failed; err=-67 Link has been severed
Message-ID: <20110621054310.GA5538@internetdog.org> (sfid-20110621_092059_032646_8E02DFDF)
Reply-To: ali@internetdog.org
References: <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0D4065B927@oxn-mx01.PD.CalAmpCorp.com>
 <39e83b34879f7b3d79534665e9dd0ae6@secure.sipsolutions.net>
 <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0D4193EA50@oxn-mx01.PD.CalAmpCorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0D4193EA50@oxn-mx01.PD.CalAmpCorp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Frederic,


On Mon, Jun 20, 2011 at 06:03:11AM -0700, Frédéric Lamorce wrote:
> What I see is that wpa_supplicant only works with wext but it does not work with nl80211.
> My device is an ath9k_htc.

are you suggesting that wpa_supplicant's CONFIG_DRIVER_NL80211
build-option does not fully work?

Just an FYI:
Till yesterday, I had some problems which, while not similar to yours,
involved failures under encryption. You can see my posts in 
http://lists.shmoo.com/pipermail/hostap/2011-June/thread.html
for comparison. Unfortunately, the -dd trace has not been accepted by
that mailing list, yet, due to its size. Perhaps you can check it in a
few days, if it remains of interest to you.

later,
ali

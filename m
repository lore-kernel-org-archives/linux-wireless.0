Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55306.mail.re4.yahoo.com ([206.190.58.185]:31055 "HELO
	web55306.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752773AbZFBPx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 11:53:26 -0400
Message-ID: <94068.60053.qm@web55306.mail.re4.yahoo.com>
Date: Tue, 2 Jun 2009 08:53:27 -0700 (PDT)
From: austinxxh-ath9k@yahoo.com
Reply-To: austinxxh-ath9k@yahoo.com
Subject: 11n mode under mesh/adhoc/station
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


for AP mode using hostapd, I can set up 11n mode:
ieee80211n=1
ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]

what about other modes, e.g. mesh, ad-hoc, station, even monitor, how can I be sure it's not running b/g mode and it's indeed set up for 11n mode, even better, it's set as 11n-only mode. Is this do-able at all? I'm using ath9k driver (atheros).

Please cc-me as I'm not on the linux-wireless@vger list.

Thanks!
X Xiao

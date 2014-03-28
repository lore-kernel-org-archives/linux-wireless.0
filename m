Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaC1Ikr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 04:40:47 -0400
Message-ID: <1395996044.4175.6.camel@jlt4.sipsolutions.net> (sfid-20140328_094052_333552_C6B6C40F)
Subject: Re: [PATCH 3/3 v2] cfg80211: slightly clean up of
 cfg80211_sme_connect()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 09:40:44 +0100
In-Reply-To: <ab90c7d3201a2a7dac6deb52e15a1d67b7049f96.1395240451.git.gamerh2o@gmail.com> (sfid-20140319_160344_083919_61D82047)
References: <1395239207.4142.25.camel@jlt4.sipsolutions.net>
	 <ab90c7d3201a2a7dac6deb52e15a1d67b7049f96.1395240451.git.gamerh2o@gmail.com>
	 (sfid-20140319_160344_083919_61D82047)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-19 at 23:02 +0800, Zhao, Gang wrote:
> Wdev->ssid_len has already been set in cfg80211_connect() and is equal
> to connect->ssid_len. Use wdev->ssid_len instead of connect->ssid_len
> so it will be consistent with previous ssid assignment statement.
> 
> If bss is found in cfg80211_get_conn_bss(), wdev->conn->state is set
> to CFG80211_CONN_AUTHENTICATE_NEXT in there. So it's not needed to set
> it manually to CFG80211_CONN_AUTHENTICATE_NEXT if bss is found in that
> function.

Applied.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2FMFyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 01:54:52 -0400
Message-ID: <1339566888.4519.2.camel@jlt3.sipsolutions.net> (sfid-20120613_075457_994116_59A7B122)
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: Thomas Pedersen <c_tpeder@qca.qualcomm.com>,
	kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 07:54:48 +0200
In-Reply-To: <CAOpc7mEZ3Wd2JajqTpj+tZXVyE_QC1=xS3gXF9eFjmCdTu8Xug@mail.gmail.com> (sfid-20120613_075354_333561_6DE4154B)
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 <1339566003.4519.1.camel@jlt3.sipsolutions.net>
	 <CAOpc7mEZ3Wd2JajqTpj+tZXVyE_QC1=xS3gXF9eFjmCdTu8Xug@mail.gmail.com>
	 (sfid-20120613_075354_333561_6DE4154B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 07:53 +0200, Holger Schurig wrote:
> @NL80211_ATTR_SCHED_SCAN_MATCH_RSSI
> 
> I'd also move around "SCHED" and "ATTR". Look at the attribute names
> above or below it, then it's more obvious:
> 
> NL80211_SCHED_SCAN_MATCH_ATTR_SSID
> NL80211_ATTR_SCHED_SCAN_MATCH_RSSI
> NL80211_SCHED_SCAN_MATCH_ATTR_MAX

Indeed, NL80211_ATTR_* is usually the namespace for the top-level
attributes.

johannes



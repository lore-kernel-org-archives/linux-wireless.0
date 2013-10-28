Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3J1OMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:12:14 -0400
Message-ID: <1382969525.17956.16.camel@jlt4.sipsolutions.net> (sfid-20131028_151217_637292_0C3E6B8F)
Subject: Re: [PATCH] mac80211_hwsim: Fix tracking of beaconing for multi-vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 28 Oct 2013 15:12:05 +0100
In-Reply-To: <20131022111117.GA9983@jouni.qca.qualcomm.com> (sfid-20131022_131126_356367_D65BE582)
References: <20131022111117.GA9983@jouni.qca.qualcomm.com>
	 (sfid-20131022_131126_356367_D65BE582)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-22 at 14:11 +0300, Jouni Malinen wrote:
> mac80211_hwsim canceled beacon_timer on any vif changing from enabled
> to disabled beaconing. This breaks cases where there are multiple
> beaconing vifs and only one of them is removed. Fix this by tracking
> beaconing status per vif and disable beacon_timer only if no active vif
> remain with beaconing enabled.

Applied.

johannes


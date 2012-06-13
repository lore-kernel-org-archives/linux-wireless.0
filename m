Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46544 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2FMUpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 16:45:41 -0400
Date: Wed, 13 Jun 2012 13:45:37 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Holger Schurig <holgerschurig@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<kvalo@qca.qualcomm.com>, <ath6kl-devel@qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning
Message-ID: <20120613204537.GA3043@pista> (sfid-20120613_224544_608851_345E0B86)
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1339566003.4519.1.camel@jlt3.sipsolutions.net>
 <CAOpc7mEZ3Wd2JajqTpj+tZXVyE_QC1=xS3gXF9eFjmCdTu8Xug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOpc7mEZ3Wd2JajqTpj+tZXVyE_QC1=xS3gXF9eFjmCdTu8Xug@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2012 at 07:53:51AM +0200, Holger Schurig wrote:
> @NL80211_ATTR_SCHED_SCAN_MATCH_RSSI
> 
> I'd also move around "SCHED" and "ATTR". Look at the attribute names
> above or below it, then it's more obvious:
> 
> NL80211_SCHED_SCAN_MATCH_ATTR_SSID
> NL80211_ATTR_SCHED_SCAN_MATCH_RSSI
> NL80211_SCHED_SCAN_MATCH_ATTR_MAX

Makes sense. In wireless-testing HEAD the SSID match attr is actually
"NL80211_ATTR_SCHED_SCAN_MATCH_SSID".

Thomas

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3GIPPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 11:15:34 -0400
Message-ID: <1373382929.8241.3.camel@jlt4.sipsolutions.net> (sfid-20130709_171539_029194_1E476BD2)
Subject: Re: [PATCH v13 1/2] cfg80211: add 'flags' to cfg80211_rx_mgmt()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Ilan Peer <ilan.peer@intel.com>
Date: Tue, 09 Jul 2013 17:15:29 +0200
In-Reply-To: <2816930.mUJMdCmsNg@lx-vladimir>
References: <1372331863-14083-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <2816930.mUJMdCmsNg@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-03 at 17:37 +0300, Vladimir Kondratiev wrote:
> Flags intended to report various auxiliary information.
> Introduced flag NL80211_RXMGMT_FLAG_REPLIED to report
> whether frame was replied by the device/driver.

This looks fine to me, but the patch is line-wrapped and won't apply:

> @@ -608,8 +608,7 @@ static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, 
> u8 *datap, int len,



You also sent me at least three versions of it and I don't really want
to figure out what that meant.

johannes


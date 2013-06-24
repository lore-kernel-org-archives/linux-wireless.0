Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3315 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3FXNql (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:46:41 -0400
Message-ID: <51C84DB4.9050703@broadcom.com> (sfid-20130624_154644_154619_F839374B)
Date: Mon, 24 Jun 2013 15:46:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	"Jouni Malinen" <jouni@qca.qualcomm.com>
Subject: Re: [PATCH v10 1/2] cfg80211: add flags to cfg80211_rx_mgmt
References: <1372063757-24286-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1372063757-24286-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
In-Reply-To: <1372063757-24286-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/24/2013 10:49 AM, Vladimir Kondratiev wrote:
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 6a43c34..29e733c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3856,6 +3856,8 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
>    * @sig_dbm: signal strength in mBm, or 0 if unknown
>    * @buf: Management frame (header + body)
>    * @len: length of the frame data
> + * @flags: various flags, see NL80211_RXMGMT_FLAG_xxx defined in
> + *	enum nl80211_rxmgmt_flags

It seems sufficient to say:

@flags: flags as defined in enum nl80211_rxmgmt_flags

Regards,
Arend

>    * @gfp: context flags



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35786 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbYBDTIE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 14:08:04 -0500
Message-ID: <47A76273.7090005@openwrt.org> (sfid-20080204_190808_149455_499BBAF0)
Date: Mon, 04 Feb 2008 20:07:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
References: <12020697053277-git-send-email-tomas.winkler@intel.com>	 <1ba2fa240802040357vf517e6as374540e28dd1ab56@mail.gmail.com>	 <47A718CF.50303@openwrt.org> <-5971017268625562167@unknownmsgid>	 <1ba2fa240802040621h2c0e9fe6yb5d84d24513aedf4@mail.gmail.com>	 <-7767648866191425885@unknownmsgid>	 <1ba2fa240802040713k56fdf22fp8ab15924bbebe88@mail.gmail.com>	 <47A72E13.8070305@openwrt.org>	 <1ba2fa240802041036v2b311eb4vcced7a9f1e2aa6a0@mail.gmail.com>	 <47A75BF5.90101@openwrt.org> <1ba2fa240802041103v622db90co2ddc24eda3347ffc@mail.gmail.com>
In-Reply-To: <1ba2fa240802041103v622db90co2ddc24eda3347ffc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> The problem that this structure is passed with each packett I don't
> like the idea that anybody would even try to allocate and free this
> structure as packets goes. However what about the following?
> 
> ieee80211_tx_status {
>          size_t nrates;
>          ieee80211_tx_ratectrl  rates[0] ;
> }
Yes, I think that would be ok.

- Felix

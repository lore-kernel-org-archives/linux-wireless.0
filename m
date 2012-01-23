Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab2AWSTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 13:19:49 -0500
To: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Subject: Re: [PATCH 1/2] mac80211: Add STBC RX flag to radiotap.  Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Mon, 23 Jan 2012 11:19:46 -0700
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>,
	Wojciech Dubowik <wojciech.dubowik@neratec.com>
In-Reply-To: <1327328861-7223-2-git-send-email-Wojciech.Dubowik@neratec.com>
 (sfid-20120123_154031_588584_A7A34697)
References: <1327328861-7223-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <1327328861-7223-2-git-send-email-Wojciech.Dubowik@neratec.com>
 (sfid-20120123_154031_588584_A7A34697)
Message-ID: <aa3e9d4dc7422d71ddd76680a74c44c2@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  #define IEEE80211_RADIOTAP_MCS_HAVE_GI		0x04
>  #define IEEE80211_RADIOTAP_MCS_HAVE_FMT		0x08
>  #define IEEE80211_RADIOTAP_MCS_HAVE_FEC		0x10
> +#define IEEE80211_RADIOTAP_MCS_HAVE_STBC	0x20

Need radiotap standardisation *FIRST* before you're allowed to touch 
this file.

johannes

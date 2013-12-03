Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:61841 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3LCJoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 04:44:44 -0500
Message-ID: <529DA7FB.6020600@lri.fr> (sfid-20131203_104452_889798_FE67BB30)
Date: Tue, 03 Dec 2013 10:44:27 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, j@w1.fi,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] cfg80211/mac80211: drop GTK-protected unicast IP packets
References: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2013 19:51, Johannes Berg wrote:
> +			if (!ipv4_is_multicast(ip.hdr4.daddr))
> +				return -1;

So broadcasting to e.g. 192.168.255.255 is now forbidden ?

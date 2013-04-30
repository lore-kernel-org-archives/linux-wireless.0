Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760460Ab3D3NnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 09:43:24 -0400
Message-ID: <1367329400.8337.6.camel@jlt4.sipsolutions.net> (sfid-20130430_154327_818974_C042154E)
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: Sreenath <sreenats@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 30 Apr 2013 15:43:20 +0200
In-Reply-To: <517FC953.3010206@broadcom.com> (sfid-20130430_154110_890405_EBC844C4)
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
	 <517FC953.3010206@broadcom.com> (sfid-20130430_154110_890405_EBC844C4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-30 at 19:08 +0530, Sreenath wrote:
> Hello Johannes,
> 
> As per this patch, the dummy 'p2p0' interface will be created only if 
> new interface creation request is for interface type - 
> NL80211_IFTYPE_P2P_DEVICE. Does that mean that this P2P hack will work 
> only with wpa_supplicant patches submitted by David Spinadel or similar 
> changes have to be done in wpa_supplicant? Because with current version 
> of wpa_supplicant there won't be any interface creation request for 
> NL80211_IFTYPE_P2P_DEVICE as the interface type.

Like I just said on the hostap list, you have to create it manually or
in a script first.

johannes


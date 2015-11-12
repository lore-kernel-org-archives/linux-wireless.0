Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54540 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbbKLUDd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 15:03:33 -0500
Message-ID: <1447358605.2131.3.camel@sipsolutions.net> (sfid-20151112_210335_993707_E767CCBB)
Subject: Re: [PATCH v2] cfg80211: add VHT support for Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Nov 2015 21:03:25 +0100
In-Reply-To: <ab294ba62856f00c06dde10b1bf57f5f341a7198.1447351137.git.poh@qca.qualcomm.com>
References: <ab294ba62856f00c06dde10b1bf57f5f341a7198.1447351137.git.poh@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-12 at 09:59 -0800, Peter Oh wrote:
> Add NL80211_EXT_FEATURE_VHT_MESH flag to allow drivers
> to indicate support for VHT in Mesh mode.
> This flag will be used by wireless drivers to indicate
> the capability of VHT Mesh support and wpa_supplicant to inspect
> wireless drivers' capability of VHT Mesh.
> In addition to this patch, separate patches to ath10k driver and
> wpa_supplicant are also sent out.
> 
Sorry, still doesn't make sense. What does userspace even need to know
this *for*?

johannes

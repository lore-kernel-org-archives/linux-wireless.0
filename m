Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37120 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760821Ab2DKTrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:47:24 -0400
Date: Wed, 11 Apr 2012 15:35:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Thomas Pedersen <c_tpeder@qca.qualcomm.com>,
	ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ath6kl: handle concurrent AP-STA channel switches
Message-ID: <20120411193542.GB2479@tuxdriver.com> (sfid-20120411_214728_250855_B2C05EE1)
References: <1333744548-18028-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1333744548-18028-2-git-send-email-c_tpeder@qca.qualcomm.com>
 <4F82FAA6.509@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F82FAA6.509@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 09, 2012 at 06:05:10PM +0300, Kalle Valo wrote:
> On 04/06/2012 11:35 PM, Thomas Pedersen wrote:
> > If an ath6kl AP vif is beaconing on one channel, and a STA vif
> > associates on a different channel, a WMI_DISCONNECT event will be sent
> > to the AP vif. Make the AP vif follow the STA interface, and notify
> > userspace.
> > 
> > Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
> 
> John, if it's ok for you I can take this patch ath6kl.git once you have
> applied the cfg80211 patch.

OK.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

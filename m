Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53285 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2HMPir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 11:38:47 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20521.7840.420228.712856@gargle.gargle.HOWL> (sfid-20120813_173851_326790_2A8CD9CC)
Date: Mon, 13 Aug 2012 21:04:56 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: [RFC 1/3] ath9k: cleanup add_iterface/change_interface
In-Reply-To: <1344871278-6499-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1344871278-6499-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> All these checks will be handled by cfg80211 based on
> the interface combination advertized. For instance
> we support 8 beacon while we advertize maximum 8
> beaconing interface in the interface combination
> support, also cfg80211 will take care of not allowing
> us to add an interface that is not supported by the
> driver, so as if the change_interface changes the
> old interface to a beaconing interface where we had
> reached the maximum number of beacoing interface

This looks good.

Sujith

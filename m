Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34803 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3DPE0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 00:26:14 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20844.53865.553932.88919@gargle.gargle.HOWL> (sfid-20130416_062619_324966_0F8B3936)
Date: Tue, 16 Apr 2013 09:54:09 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k-devel@qca.qualcomm.com
Subject: Re: ath10k: mac80211 driver for QCA9880
In-Reply-To: <516CCBDA.6070409@candelatech.com>
References: <87li8k0yu1.fsf@kamboji.qca.qualcomm.com>
	<516CCBDA.6070409@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Is there any info on it's expected support for virtual stations, APs, etc?

There are limitations on the maximum number of virtual interfaces and stations
right now. But, the FW is being fixed to support more nodes/interfaces.
Nevertheless, it can't be compared with ath9k. :)

Sujith

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17959 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2BUOTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 09:19:49 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.42996.812899.286799@gargle.gargle.HOWL> (sfid-20120221_151953_745026_F8BE93B9)
Date: Tue, 21 Feb 2012 19:49:32 +0530
To: Peter Stuge <peter@stuge.se>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] [RFC/WIP 01/22] ath9k: Remove AR9462 v1.0 support
In-Reply-To: <20120221123952.24846.qmail@stuge.se>
References: <20291.25151.337645.330386@gargle.gargle.HOWL>
	<20120221123952.24846.qmail@stuge.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Stuge wrote:
> Sujith Manoharan wrote:
> > v1.0 chips are not available in the market.
> 
> Maybe delete the macro as well then.

Thanks for catching this, I'll fix it.

Sujith

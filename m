Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:42254 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929AbcESSbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 14:31:37 -0400
Date: Thu, 19 May 2016 11:31:35 -0700 (PDT)
Message-Id: <20160519.113135.2232299642544593300.davem@davemloft.net> (sfid-20160519_203202_614677_CBCBB12F)
To: xypron.glpk@gmx.de
Cc: kvalo@codeaurora.org, hofrat@osadl.org, johannes.berg@intel.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: rsi: eliminate superfluous NULL check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1463524241-11351-1-git-send-email-xypron.glpk@gmx.de>
References: <1463524241-11351-1-git-send-email-xypron.glpk@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Date: Wed, 18 May 2016 00:30:41 +0200

> msg is dereferenced before checking against NULL, e.g.
> when assigning pad_bytes.
> Remove the superfluous check in function rsi_mgmt_pkt_to_core.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

I'll let the wireless folks pick this up.

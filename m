Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49569 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759428Ab3ICGZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 02:25:44 -0400
Message-ID: <522580E2.2090501@openwrt.org> (sfid-20130903_082547_450612_F26E1F71)
Date: Tue, 03 Sep 2013 08:25:38 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] initvals: Remove duplicate mapping for AR9485 arrays
References: <1378184318-1169-1-git-send-email-sujith@msujith.org> <1378184318-1169-2-git-send-email-sujith@msujith.org>
In-Reply-To: <1378184318-1169-2-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-09-03 6:58 AM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Why did you make this change? At least the mac_postamble is still
identical, and with the other arrays you can just let the initvals tool
detect if mappings are duplicate or not.

- Felix

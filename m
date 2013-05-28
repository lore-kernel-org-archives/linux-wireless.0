Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46265 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab3E1UV1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 16:21:27 -0400
Message-ID: <51A511BF.8050305@openwrt.org> (sfid-20130528_222136_248036_CA6CA08E)
Date: Tue, 28 May 2013 22:21:19 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	felixb@qca.qualcomm.com
Subject: Re: [PATCH] ath9k_hw: fix PA predistortion miscalibration
References: <1369757084-50141-1-git-send-email-nbd@openwrt.org> <20130528174519.GH2084@tuxdriver.com>
In-Reply-To: <20130528174519.GH2084@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-28 7:45 PM, John W. Linville wrote:
> Is this a fix for 3.10?  Should it go to stable?
PA predistortion has been disabled for a few releases now. It'll
probably take some time to get this functionality properly validated, so
having this fix in 3.11 is good enough.

- Felix


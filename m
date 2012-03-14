Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39619 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759147Ab2CNMqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 08:46:32 -0400
Message-ID: <4F609324.2030401@openwrt.org> (sfid-20120314_134635_299195_71CDBF06)
Date: Wed, 14 Mar 2012 13:46:28 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: Don't sample max throughput rate in minstrel_ht
References: <1331728271-7645-1-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1331728271-7645-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-14 1:31 PM, Helmut Schaa wrote:
> The current max throughput rate is known to be good as otherwise it
> wouldn't be the max throughput rate. Since rate sampling can introduce
> some overhead (by adding RTS for example or due to not aggregating the
> frame) don't sample the max throughput rate.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:52362 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaIIVgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 17:36:41 -0400
Message-ID: <540F72E4.2090000@openwrt.org> (sfid-20140909_233645_293082_15F3BA8A)
Date: Tue, 09 Sep 2014 23:36:36 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	ikstream86@gmail.com
Subject: Re: [PATCH v2 0/2] Unify & improve Minstrel & Minstrel_HT rate control
References: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-09-09 23:22, Thomas Huehn wrote:
> This patch series consolidates rate statistic variables between Minstrel and
> Minstrel_HT. It improves the sorting function to find the max throughput rate
> set in Minstrel_HT.
For this series:

Acked-by: Felix Fietkau <nbd@openwrt.org>

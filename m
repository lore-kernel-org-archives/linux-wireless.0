Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:44221 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbaIHQac (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:30:32 -0400
Message-ID: <540DD99D.3060705@openwrt.org> (sfid-20140908_183036_544180_B61853E3)
Date: Mon, 08 Sep 2014 18:30:21 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	ikstream86@gmail.com
Subject: Re: [PATCH 1/2] mac80211: Unify rate statistic variables between
 Minstrel & Minstrel_HT
References: <1408716333-18492-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1408716333-18492-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1408716333-18492-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-08-22 16:05, Thomas Huehn wrote:
> Minstrel and Mintrel_HT use individual structs to keep track of rate
> statistics. Unify those variables in struct minstrel_rate_stats and
> move it to rc80211_minstrel.h for common usage. This is a clean-up
> patch to prepare Minstrel and Minstrel_HT codebase for upcoming TPC.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Acked-by: Felix Fietkau <nbd@openwrt.org>

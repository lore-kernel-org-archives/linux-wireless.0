Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46336 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbbCYAQI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 20:16:08 -0400
Message-ID: <5511FE44.3070802@openwrt.org> (sfid-20150325_011612_304397_2F67CDB4)
Date: Wed, 25 Mar 2015 01:16:04 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: Re: [PATCH v4 0/10] Improve Minstrels & Minstrel-HTs common code
 base & statistics
References: <1427227783-4531-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1427227783-4531-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-24 21:09, Thomas Huehn wrote:
> This patch series adds several improvements to the readability, the
> output format of rc_stats and the calculated statistics of Minstrel
> and Minstrel-HT. Variable names got more consistent and functions
> got unified between both rate control algorithms.
Acked-by: Felix Fietkau <nbd@openwrt.org>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58591 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbbFQJvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:51:54 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21889.17231.626144.14969@gargle.gargle.HOWL> (sfid-20150617_115157_735213_9ACBA363)
Date: Wed, 17 Jun 2015 15:22:15 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFCv2] ath9k: make rxfilter per HW
In-Reply-To: <55814109.7030100@openwrt.org>
References: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>
	<21889.11726.101648.552280@gargle.gargle.HOWL>
	<55812FB5.1070005@openwrt.org>
	<21889.14109.54454.563245@gargle.gargle.HOWL>
	<CALhHN=ro4K6mALLHqgVRGm50UGg5hh9mnSSAnNHwZdZ5ywOk-Q@mail.gmail.com>
	<21889.16487.258289.588207@gargle.gargle.HOWL>
	<55814109.7030100@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> The filter is intended to be global in the mac80211 API.
> Treating it as per channel-context inside the driver is a bug.

Agreed.

Sujith

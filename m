Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34610 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab3KHQjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 11:39:21 -0500
Message-ID: <527D13B7.3000206@openwrt.org> (sfid-20131108_173925_045849_6FFF4388)
Date: Fri, 08 Nov 2013 17:39:19 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: minstrels: spare numerous useless calls
 to get_random_bytes
References: <1383928473-798-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1383928473-798-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-08 17:34, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> These are called to init the sample tables.
> This occurs once in minstrel_ht upon its registration (since it uses one
> single common sample table for all STAs), and once per sta addition in
> minstrel.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36456 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab3CDWeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 17:34:12 -0500
Message-ID: <5135215F.80707@openwrt.org> (sfid-20130304_233415_444473_9DE910AD)
Date: Mon, 04 Mar 2013 23:34:07 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH v4 0/7] mac80211: improve and consolidate minstrel rate
 control
References: <1362436208-75786-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1362436208-75786-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-04 11:30 PM, Thomas Huehn wrote:
> This patch series merges functions, macros and sampling improvements from
> minstrel_ht into minstrel. It adds several improvements to the rate control.
> 
> Thomas
> 
> v2: remove debugging output (thx to Bob Copeland)
> v3: fix array initialization in init_sample_table (thx to Johannes Berg)
> v4: fix missing bitmask to access rnd[8] properly (thx to Felix Fietkau)
For the whole series:
Acked-by: Felix Fietkau <nbd@openwrt.org>


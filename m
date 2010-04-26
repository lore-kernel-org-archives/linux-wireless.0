Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48987 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab0DZXaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 19:30:04 -0400
Message-ID: <4BD621FA.1000405@openwrt.org>
Date: Tue, 27 Apr 2010 01:30:02 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] cfg80211: add ap isolation support
References: <1272324216-73349-1-git-send-email-nbd@openwrt.org> <20100426232332.GA2079@tuxdriver.com>
In-Reply-To: <20100426232332.GA2079@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-27 1:23 AM, John W. Linville wrote:
> On Tue, Apr 27, 2010 at 01:23:35AM +0200, Felix Fietkau wrote:
>> This is used to configure APs to not bridge traffic between connected stations.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> Is this useful?
Yes, if you have an AP with lots of users that aren't expected to
communicate with each other (e.g. only for internet access), it can save
a lot of airtime by not forwarding every broadcast message emitted from
any station.
I'm sure there are a more situations where this can be useful.

- Felix

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46661 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759404Ab1CDRGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 12:06:36 -0500
Message-ID: <4D711C18.9020702@openwrt.org>
Date: Fri, 04 Mar 2011 18:06:32 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211: Remove redundant preamble and RTS flag
 setup in minstrel_ht
References: <1299241892-6719-1-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1299241892-6719-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-04 1:31 PM, Helmut Schaa wrote:
> mac80211 does the same afterwards anyway. Hence, just drop
> this redundant code.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>

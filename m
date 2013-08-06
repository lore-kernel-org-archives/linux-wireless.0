Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52899 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab3HFJtX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:49:23 -0400
Message-ID: <5200C6A1.3040902@openwrt.org> (sfid-20130806_114926_096193_FF686E6F)
Date: Tue, 06 Aug 2013 11:49:21 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 09/12] ath9k: always clear ps filter bit on new assoc
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org> <1375732583-39001-9-git-send-email-nbd@openwrt.org> <20992.44003.432490.369935@gargle.gargle.HOWL>
In-Reply-To: <20992.44003.432490.369935@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-06 9:55 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Otherwise in some cases, EAPOL frames might be filtered during the
>> initial handshake, causing delays and assoc failures.
> 
> I think this is a stable candidate.
Okay, will add Cc:stable in v2.

- Felix

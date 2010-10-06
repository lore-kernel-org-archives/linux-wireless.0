Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41700 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab0JFCp6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 22:45:58 -0400
Message-ID: <4CABE2DA.5020204@openwrt.org>
Date: Wed, 06 Oct 2010 04:45:46 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, vasanth@atheros.com,
	linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath5k: Add busy ratios to survey data
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095531.3083.39403.stgit@tt-desk> <AANLkTimP=R4hsCWU+wP1aemHn1awzNQVWMa-_7OJEQLG@mail.gmail.com> <201010061125.54247.br1@einfach.org>
In-Reply-To: <201010061125.54247.br1@einfach.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-06 4:25 AM, Bruno Randolf wrote:
> On Wed October 6 2010 07:38:34 Luis R. Rodriguez wrote:

>> This is all being sucked out of common, so can we just share the
>> filler for the survey between ath5k and ath9k? Note we should split up
>> hw code and core driver code on the ath module by file.
> 
> sure, that would be good! noise floor comes from ath5k_hw though, but that can 
> easily be moved to common. 
> 
> there's so much code which could be shared between ath5k and ath9k...
That would need sharing of the channel list and some per-channel data
though - so it may need some more code reshuffling...

- Felix

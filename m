Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62621 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817AbZGPRZr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 13:25:47 -0400
Subject: Re: [PATCH v2 16/21] mac80211: add helper for management / no-ack
 frame rate decision
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Gabor Juhos <juhosg@openwrt.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
In-Reply-To: <1247763941-21396-1-git-send-email-lrodriguez@atheros.com>
References: <1247763941-21396-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 10:25:47 -0700
Message-Id: <1247765147.17896.2284.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-16 at 10:05 -0700, Luis R. Rodriguez wrote:
> All current rate control algorithms agree to send management and no-ack
> frames at the lowest rate. They also agree to do this when sta
> and the private rate control data is NULL. We add a hlper to mac80211
> for this and simplify the rate control algorithm code.
> 
> Developers wishing to make enhancements to rate control algorithms
> are for broadcast/multicast can opt to not use this in their
> gate_rate() mac80211 callback.
> 
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: ipw3945-devel@lists.sourceforge.net
> Cc: Gabor Juhos <juhosg@openwrt.org>
> Cc: Felix Fietkau <nbd@openwrt.org>
> Cc: Derek Smithies <derek@indranet.co.nz>
> Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---


For the iwlwifi bits ...

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette



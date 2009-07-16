Return-path: <netrolller.3d@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1247763941-21396-1-git-send-email-lrodriguez@atheros.com>
References: <1247763941-21396-1-git-send-email-lrodriguez@atheros.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 16 Jul 2009 19:33:01 +0200
Message-ID: <69e28c910907161033o1385f70bh3059d62f59bbb31c@mail.gmail.com>
Subject: Re: [PATCH v2 16/21] mac80211: add helper for management / no-ack
	frame rate decision
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Zhu Yi <yi.zhu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net, Gabor Juhos <juhosg@openwrt.org>,
	Felix Fietkau <nbd@openwrt.org>, Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 7:05 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
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

ACK.

This will hopefully stop buggy algorithms from cropping up in the future.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

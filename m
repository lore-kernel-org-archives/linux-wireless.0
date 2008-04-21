Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45082 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbYDUB33 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 21:29:29 -0400
Subject: Re: FYI: hostapd status
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1208454990.4066.42.camel@johannes.berg>
References: <1208454990.4066.42.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Apr 2008 09:28:39 +0800
Message-Id: <1208741320.2452.22.camel@debian.sh.intel.com> (sfid-20080421_022946_301296_636FD25D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-04-17 at 19:56 +0200, Johannes Berg wrote:
> Since we just talked about it on IRC and I made a list, here it is. T=
his
> lists what we're missing in mac80211 and nl80211 for proper AP suppor=
t.
>=20
> =EF=BB=BF * short slot        =20
>  * short preamble
>  * basic rate set=20
>  * rts/cts
>  * channel flag/regulatory domain
>  * tx queue params (the plan is to make them qdisc settings after
>    Ron's/my qos patch)
>  * multi-bss support (no kernel changes, just hostapd keep track of
>    BSSes)
>  * internal bridge setting (separated STAs in AP, local->bridge_packe=
ts)
>  * CTS-protect setting for AP

These looks good for a basic AP. But I'd like to add more advanced
features for example 11n, WMM AC and u-APSD support (which we have
already done).

>  * check why we see data frames on cooked monitor
>  * investigate the skb truesize bug

These are bugs must be fixed ASAP.

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

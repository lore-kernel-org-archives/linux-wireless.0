Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35323 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567Ab3JON3p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:29:45 -0400
Message-ID: <525D4347.5020902@openwrt.org> (sfid-20131015_152948_084230_8AEB4E6B)
Date: Tue, 15 Oct 2013 15:29:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Floris Van den Abeele <floris.vandenabeele@intec.ugent.be>,
	linux-wireless@vger.kernel.org
Subject: Re: Lower throughput in Ad-hoc than in Infrastructure mode?
References: <525CEE98.3010300@intec.ugent.be>
In-Reply-To: <525CEE98.3010300@intec.ugent.be>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-10-15 9:28 AM, Floris Van den Abeele wrote:
> While running throughput experiments using iperf I noticed that UDP
> throughput in ad-hoc mode was considerably lower than in Infrastructure
> mode. The setups I'm comparing is a 802.11a ad-hoc network consisting of
> two clients vs a 802.11a infrastructure network consisting of an access
> point and a client (11a because the tests were run in the 5GHz band).
> 
> For ad-hoc mode I'm consistenly seeing a lower throughput than for
> infrastructure mode: i.e. 22.4 Mbits/sec vs 28.2 Mbits/sec. Note that
> while sniffing the medium radiotap headers report a PHY data rate of
> 54Mbit/s in both cases. There is no other traffic on the Wi-Fi channel
> in question (44). Considering the medium access for both setups is
> similair I would expect to find similair throughputs. Is this a known
> issue with the linux wireless/mac80211/ath9k driver stack or is this
> behaviour conform the 802.11 standard (based on my knowledge I would say
> no to the latter)? My test specs are below.
> 
> For testing I'm using Sparklan WPEA-111N NIC's (AR9280). The nodes are
> running OpenWrt attitude adjusment on r32482 (from 2012-06-21) with the
> REGD patch enabled. I believe that this build of OpenWRT uses the
> compat-wireless-2012-06-14.tar.bz2 drivers.
I'd suggest that you try a recent version of OpenWrt before
investigating further.

- Felix


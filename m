Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3J1OhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:37:11 -0400
Message-ID: <1382971021.17956.25.camel@jlt4.sipsolutions.net> (sfid-20131028_153716_103618_218A746E)
Subject: Re: [PATCH] nl80211: introduce NL80211_SCAN_FLAG_DISCOVERY_MODE
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Mon, 28 Oct 2013 15:37:01 +0100
In-Reply-To: <1382889282-12880-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1382889282-12880-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-10-27 at 17:54 +0200, Vladimir Kondratiev wrote:
> for the DMG (60GHz) networks, there is new scan parameter added in the 802.11 spec -
> DiscoveryMode.  This parameter defines whether station performing active scan shall
> generate special form of DMG beacons. In particular, this flag used in the P2P
> discovery.

Max 72 chars per line please.

> + * @NL80211_SCAN_FLAG_DISCOVERY_MODE: scan to use discovery mode, as in

"scan to use" - did you mean "scan using"?

Also what about a feature flag? Though I suppose this should be
supported by all 60GHz devices (and only those)?

johannes


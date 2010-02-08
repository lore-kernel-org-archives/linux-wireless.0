Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hogsmeade.leitwerk.net ([217.28.96.50]:42864 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0BHNyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 08:54:15 -0500
From: Simon Raffeiner <sturmflut@lieberbiber.de>
To: Andrey Yurovsky <andrey@cozybit.com>
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh mode
Date: Mon, 8 Feb 2010 14:54:13 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com> <1265446793.4041.2.camel@johannes.local> <c1545bb51002071151wb2cefa3mb03501e0d6b3fb4b@mail.gmail.com>
In-Reply-To: <c1545bb51002071151wb2cefa3mb03501e0d6b3fb4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201002081454.13561.sturmflut@lieberbiber.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sonntag 07 Februar 2010 08:51:03 pm schrieben Sie:

> It was supported for automated testing and experimentation (you could
> then force certain topologies). 

Wouldn't one have to disable beaconing then, or at least automatic peering? IMO you can't force a topology if the nodes are still beaconing and establishing paths at the same time.

regards
Simon Raffeiner

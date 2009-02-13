Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23411 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZBMFH6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:07:58 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:07:58 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18836.65353.489754.511505@gargle.gargle.HOWL> (sfid-20090213_060802_847285_7DFA7F7B)
Date: Fri, 13 Feb 2009 10:34:09 +0530
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: fix aggregation for hardware with ampdu queues
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A353F1ACF4B@orsmsx506.amr.corp.intel.com>
References: <1234396313.16004.65.camel@johannes.local>
	<18835.43402.286764.192456@gargle.gargle.HOWL>
	<E9954878DD1FB34FAE5187FB88C58A353F1ACF4B@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy, Wey-Yi W wrote:
> Thanks for testing. Do you agree the medium-term sulution?
> 

Yep, looks okay, and doesn't seem to affect ath9k. Thanks.

Sujith

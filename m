Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0KWDBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 22:01:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
Reply-To: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] mac80211: make ieee802_1d_to_ac avilable to drivers
References: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 23 Nov 2010 04:01:28 +0100
Message-Id: <1290481288.3070.2.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +++ b/include/net/mac80211.h

> +static const int ieee802_1d_to_ac[8] = {

this will duplicate the table in every file including the header, and sparse might warn, are you sure that's a good plan?

Johannes

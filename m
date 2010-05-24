Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0EXIEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:04:40 -0400
Subject: Re: [PATCH] Silence debug prints when using adhoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100523163133.GA19669@nalle>
References: <20100523162240.GZ19669@nalle>  <20100523163133.GA19669@nalle>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 10:04:36 +0200
Message-ID: <1274688276.3743.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-05-23 at 19:31 +0300, Mikko Rapeli wrote:

> [   14.901816] wlan0: Selected IBSS BSSID 06:be:a1:c9:16:c0 based on configured SSID
> [   16.231904] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   16.231914] IP: [<f8309788>] iwl3945_request_scan+0x39a/0x50b [iwl3945]

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2208

johannes


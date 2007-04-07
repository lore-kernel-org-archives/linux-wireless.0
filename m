Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:58556 "EHLO
	p15091797.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965480AbXDGH4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 03:56:06 -0400
Date: Sat, 7 Apr 2007 09:56:03 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Jouni Malinen <j@w1.fi>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: ieee80211: Spamming of log resulting from packets with ExtIV not set
Message-ID: <20070407075603.GA1724@p15091797.pureserver.info>
References: <4616DD7E.6010606@lwfinger.net> <20070407013848.GG16197@jm.kir.nu> <46171B36.6090108@lwfinger.net> <20070407043310.GH16197@jm.kir.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070407043310.GH16197@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-04-06 21:33 Jouni Malinen wrote:

> I would expect most wlan designs to do FCS error filtering in hardware,
> so this could be just lack of configuring something differently or
> dropping frames based on one of the RX flags. If the exact mechanism for
> this is not known, I would recommend validating FCS in software prior to
> processing the its contents (or trying to decrypt it for that matter).

Just for clarification: ZD1211 does the FCS check in hardware, but
reports the packet to the host with an error bit set, so the
driver needs to filter the packet out.

-- 
Uli Kunitz

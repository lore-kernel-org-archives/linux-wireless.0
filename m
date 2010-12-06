Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39214 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LFPa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 10:30:28 -0500
Message-ID: <4CFD019E.6050204@lwfinger.net>
Date: Mon, 06 Dec 2010 09:30:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Machek <pma@sysgo.com>
CC: kernel list <linux-kernel@vger.kernel.org>,
	chunkeey@googlemail.com, linux-wireless@vger.kernel.org,
	rudolf.marek@sysgo.com, cko@sysgo.com, mfa@sysgo.com,
	anl@sysgo.com, vojtech@ucw.cz
Subject: Re: working usb wifi card, that is still possible to buy
References: <20101103092431.GA21138@pma.sysgo.com> <20101124081616.GA30595@pma.sysgo.com> <20101124131320.GA2611@pma.sysgo.com> <20101206083718.GA27061@pma.sysgo.com>
In-Reply-To: <20101206083718.GA27061@pma.sysgo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2010 02:37 AM, Pavel Machek wrote:
> Hi!
> 
> So... these are my results of wifi testing. 802.11n driver currently
> working on powerpc is rtl8712 -- staging -- EMTEC Wi350 ...

Good to hear as I have no big-endian system for tests. Converting that driver to
work with mac80211 is on my todo list.

Larry

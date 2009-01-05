Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47120 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZAEF1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 00:27:24 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2009 21:27:23 -0800
Date: Mon, 5 Jan 2009 10:57:09 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Message-ID: <20090105052709.GA19024@vasanth-laptop> (sfid-20090105_062737_633628_80B864E0)
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com> <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com> <20090103084637.GA31929@vasanth-laptop> <69e28c910901031241iaef37d5t2cb11bf867f75c86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910901031241iaef37d5t2cb11bf867f75c86@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 04, 2009 at 02:11:01AM +0530, Stefanik G=E1bor wrote:

> Broadcom's BT coex was also running correctly on Windows Vista, but i=
t
> still caused problems on Linux.

I dont know about Broadcom BT coex implementation and issues. As far
as Atheros chip is cocerned the BT Coex stuff is fully taken care in
h/w. All I can say is, this BT Coex has gone through enough
throughput testing on BT coex aware/unaware platforms to make sure
it does not break anything both on Linux and Windows. Lets not add=20
any module parameter to enable/disable BT coex for no reason.

Vasanth=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

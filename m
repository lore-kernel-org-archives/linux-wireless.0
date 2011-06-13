Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46604 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1FMP5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 11:57:04 -0400
Received: by qyk7 with SMTP id 7so913068qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 08:57:03 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Jun 2011 17:57:03 +0200
Message-ID: <BANLkTin2cmA1RH5uDSmGOm4nAvicqiiQ6A@mail.gmail.com> (sfid-20110613_175708_920762_6C9E188F)
Subject: Question about hosts drivers split between ssb and b43
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What is the reason of splitting few hosts drivers (sdio and pcmcia)
into two pieces: one in the ssb and second in b43?

Why we didn't put everything in ssb? If sounds more reasonable (just)
*for me* and it looks like less messing since we try to add support
for BCMA in b43.

-- 
Rafał

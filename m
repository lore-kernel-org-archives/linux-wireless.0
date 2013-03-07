Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34461 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab3CGNDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 08:03:23 -0500
Received: by mail-ob0-f171.google.com with SMTP id x4so313423obh.2
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 05:03:22 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 7 Mar 2013 14:03:21 +0100
Message-ID: <CACna6rzrtAu4z4tAYWhd-W=-2CRjWVzKY7USe13x2kcZhm8LjA@mail.gmail.com> (sfid-20130307_140326_877394_CF6D1A06)
Subject: BCM4331 dump of MMIO ops - split into names parts
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: b43-dev <b43-dev@lists.infradead.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've managed to notice many interesting parts in the BCM4331 MMIO dump
(mostly by comparing it to the N-PHY code and looking for similar
operations). I believe it's possible to improve b43 now a lot. We have
PHY ops and logic (conditions, etc.) can probably be taken from
existing N-PHY.

I'm posting it in case someone is interested in taking a look at this.

I don't want to spam everyone at linux-wireless@ with 50KiB, so I'll
send the log to the b43-dev only.

-- 
Rafał

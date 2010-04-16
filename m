Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42835 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0DPGUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:20:52 -0400
Received: by wwb24 with SMTP id 24so954066wwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 23:20:51 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 16 Apr 2010 08:20:51 +0200
Message-ID: <p2ub170af451004152320y64c4615ub3d7186d936cdc62@mail.gmail.com>
Subject: [PATCH PING] ssb patches for SPROM location
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, I posted some time ago following patches:

[RFT][PATCH] ssb: Look for SPROM at different offset on higher rev CC
[PATCH 1/2] ssb: Use relative offsets for SPROM
[PATCH 2/2] ssb: Fix order of definitions and some text space indents

while Michael has some doubts about "ssb: Look for SPROM at different
offset on higher rev CC" I explained to him that what he does not like
was fixed in next 2 posted patches.

AFAIR you got some device with this recently-discovered location of
SPROM. Could you test my set if it makes your card working? If so,
could you take that patches to your tree?

-- 
Rafał

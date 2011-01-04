Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41530 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab1ADPuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 10:50:55 -0500
Received: by vws16 with SMTP id 16so6097851vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 07:50:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292963384-23684-1-git-send-email-zajec5@gmail.com>
References: <1292963384-23684-1-git-send-email-zajec5@gmail.com>
Date: Tue, 4 Jan 2011 16:50:54 +0100
Message-ID: <AANLkTikwKOLJ6A-DTEuVg43_g_cWgDg2xK4M6qQ0Lm4U@mail.gmail.com>
Subject: Re: [PATCH] b43: N-PHY: enable support for PHYs rev 3 and higher
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 21 grudnia 2010 21:29 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> John: can we still make it for 2.6.38 merge? It was tested with 14e4:432b,
> support seems to be on the same level as for PHYs 1 and 2.

John, I dont see patches for rev3+ in wireless-testing. Any problems with them?

It means:
[PATCH 1/4] b43: use correct firmware for newer cores
[PATCH 2/4 v2] b43: N-PHY: implement radio 2056 init steps
[PATCH 3/4] b43: N-PHY: add init tables for 2056 radio
[PATCH 4/4] b43: N-PHY: avoid PHY hangs for rev 3 and 4

[PATCH 1/2] b43: N-PHY: use correct channel tables for rev4+
[PATCH 2/2 v2] b43: N-PHY: update 2056 radio on channel switch on rev3+
and this one.

-- 
Rafał

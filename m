Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55083 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab2JYQr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 12:47:56 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so949843wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 09:47:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351183169-13392-1-git-send-email-hauke@hauke-m.de>
References: <1351183169-13392-1-git-send-email-hauke@hauke-m.de>
Date: Thu, 25 Oct 2012 18:47:55 +0200
Message-ID: <CACna6rwYraTcddRHUh-5a_cQ4QkLiUKrLO5FYvnMneTtWpYEwg@mail.gmail.com> (sfid-20121025_184800_133853_F4D99DE3)
Subject: Re: [PATCH 1/2] ssb: add PCI ID 0x4350
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, m@bues.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/10/25 Hauke Mehrtens <hauke@hauke-m.de>:
> 14e4:4350 is found on a Broadcom BCM43222.

Huh, I expected BCM43222 to be BCMA based, interesting. Could you
provide ssb log for scanning (cores listing) and PHY&RADIO info?

-- 
Rafał

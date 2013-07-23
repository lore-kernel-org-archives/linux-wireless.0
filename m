Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45321 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab3GWN4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 09:56:08 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so3035279bkc.14
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jul 2013 06:56:07 -0700 (PDT)
Message-ID: <51EE8B74.8080206@gmail.com> (sfid-20130723_155621_752701_26B3EE95)
Date: Tue, 23 Jul 2013 15:56:04 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: treeve@scarlet.be, linux-wireless <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [NETWORKING DRIVERS RT2X00] please add support for Asus PCE-N53
  (0x1814, 0x5592)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Treeve Jelbert wrote:

> linux-3.10.0 does not support device  (0x1814, 0x5592) Asus PCE-N53 which I 
> would like to use on with 5GHz network.
> 
> #lspci
> 02:00.0 Network controller: Ralink corp. Device 5592
>         Subsystem: ASUSTeK Computer Inc. Device 851a
> 
> # lspci -d :5592 -nn
> 02:00.0 Network controller [0280]: Ralink corp. Device [1814:5592]

RT5592 devices are still unsupported by rt2x00 drivers.
Stanislaw Gruszka <stf_xl@wp.pl> was working on it.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46611 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2KRLF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 06:05:29 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so145786wer.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Nov 2012 03:05:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1347376511-20953-1-git-send-email-hauke@hauke-m.de>
References: <1347376511-20953-1-git-send-email-hauke@hauke-m.de>
Date: Sun, 18 Nov 2012 12:05:27 +0100
Message-ID: <CACna6rw0Qy2=zo6wHcq20JBM8OJb-wnZJGLH3dksaLGFoyp+=w@mail.gmail.com> (sfid-20121118_120543_104842_9A042C11)
Subject: Re: [PATCH v4 0/3] MIPS: BCM47xx: use gpiolib
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org, john@phrozen.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/11 Hauke Mehrtens <hauke@hauke-m.de>:
> The original code implemented the GPIO interface itself and this caused
> some problems. With this patch gpiolib is used.
>
> This is based on mips/master.
>
> This should go through linux-mips, John W. Linville approved that
> for the bcma and ssb changes normally maintained in wireless-testing.

Ping? Did it go upstream? I can't find that commits in
http://git.kernel.org/?p=linux/kernel/git/ralf/linux.git;a=summary

-- 
Rafał

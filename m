Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:59526 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaGCMcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 08:32:20 -0400
Received: by mail-oa0-f45.google.com with SMTP id o6so107713oag.32
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2014 05:32:19 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Jul 2014 14:32:19 +0200
Message-ID: <CACna6rxVjnpMgQx9+d_LbROYNnnjnuMEGo-38MPwjsPtxYdN8w@mail.gmail.com> (sfid-20140703_143223_738984_E3522C8E)
Subject: Looking for someone with BCM43227 and (maybe) compilation skill ;)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I want to add support for BCM43227 in b43, however I need help of some
BCM43227 owner. Well, I could buy one by myself (less than 10$ on
eBay), but I don't want to wait a month to receive it.

So I need someone with:
1) BCM43227 ;)
2) Kernel with CONFIG_MMIOTRACE=y*
3) Broadcom Linux STA driver 6.30.223.141

So? Is there anyone around with BCM43227 willing to help?

* Ubuntu 14.04 has CONFIG_MMIOTRACE=y by default, openSuSE 13.1
doesn't. So you may need to compile kernel by yourself, depending on
the distro.

-- 
Rafał

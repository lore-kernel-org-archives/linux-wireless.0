Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40971 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3BRQUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 11:20:36 -0500
Received: by mail-ob0-f170.google.com with SMTP id wc20so5817579obb.29
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 08:20:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512236F9.1040907@gmail.com>
References: <512236F9.1040907@gmail.com>
Date: Mon, 18 Feb 2013 17:20:35 +0100
Message-ID: <CACna6rw_i28rbsHPLAC4nkVdpcdRmqhNNYMp_AqG8e5EvbpaoA@mail.gmail.com> (sfid-20130218_172039_891412_6A5AD680)
Subject: Re: BCM4331
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: lina <lina.lastname@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/2/18 lina <lina.lastname@gmail.com>:
> A quick question, does the latest kernel support the bcm4331 wireless
> card? or does it still need compat-wireless and etc.

Hint #1: b43-dev ML
Hint #2: http://wireless.kernel.org/en/users/Drivers/b43

BCM4331 support is very poor, there aren't *any* specs for HT-PHY that
is used in BCM4331. All I've written was based on MMIO dumps of closed
source driver (running in ndiswrapper).

-- 
Rafał

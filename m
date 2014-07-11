Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [199.83.51.51] ([199.83.51.51]:51353 "EHLO mantis.wzyboy.im"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaGKHTT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 03:19:19 -0400
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com [209.85.213.173])
	by mantis.wzyboy.im (Postfix) with ESMTPSA id 42FA488064
	for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 15:10:24 +0800 (CST)
Received: by mail-ig0-f173.google.com with SMTP id h18so2779673igc.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 00:10:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALkVjQbNMNs__LsNG450fCpTNmAR3kfDFn2o7xxrdLjSi1wu=w@mail.gmail.com>
References: <CALkVjQbNMNs__LsNG450fCpTNmAR3kfDFn2o7xxrdLjSi1wu=w@mail.gmail.com>
From: Sascha Weaver <wzyboy@wzyboy.org>
Date: Fri, 11 Jul 2014 15:10:08 +0800
Message-ID: <CALkVjQbmrypdzG9B2nQ1oCPGuzO2Va0_vcpvkQmdtOsWP2HHZA@mail.gmail.com> (sfid-20140711_091922_815279_A79B8235)
Subject: Re: [iwlwifi] Wireless-AC 7260 disconnects every half and hour
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-07-11 15:06 GMT+08:00 Sascha Weaver <wzyboy@wzyboy.org>:
> I recently bought an Intel Wireless-AC 7260 (Dual band) to replace my
> Intel Wireless-N 7260.


Sorry, I forgot to include the kernel information:

I am using Arch Linux with kernel 3.15.4. The firmware information is:

filename: /lib/modules/3.15.4-1-ARCH/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko.gz
license: GPL
author: Copyright(c) 2003- 2014 Intel Corporation <ilw@linux.intel.com>
version: in-tree:
description: Intel(R) Wireless WiFi driver for Linux
firmware: iwlwifi-100-5.ucode
firmware: iwlwifi-1000-5.ucode
firmware: iwlwifi-135-6.ucode
firmware: iwlwifi-105-6.ucode
firmware: iwlwifi-2030-6.ucode
firmware: iwlwifi-2000-6.ucode
firmware: iwlwifi-5150-2.ucode
firmware: iwlwifi-5000-5.ucode
firmware: iwlwifi-6000g2b-6.ucode
firmware: iwlwifi-6000g2a-5.ucode
firmware: iwlwifi-6050-5.ucode
firmware: iwlwifi-6000-4.ucode
firmware: iwlwifi-7265-8.ucode
firmware: iwlwifi-3160-8.ucode
firmware: iwlwifi-7260-8.ucode
firmware: iwlwifi-8000-8.ucode
srcversion: 8DF2F6932FD2B1941BD7397



-- 
Sascha Weaver

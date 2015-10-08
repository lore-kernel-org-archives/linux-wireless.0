Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f193.google.com ([209.85.217.193]:35078 "EHLO
	mail-lb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbbJHS3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:29:42 -0400
Message-ID: <5616B60F.7040804@gmail.com> (sfid-20151008_203001_723447_3644856F)
Date: Thu, 08 Oct 2015 21:29:35 +0300
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
MIME-Version: 1.0
To: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org
CC: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: staging: wilc1000: WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I noticed that drivers/staging/wilc1000/Kconfic defines:

config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
        bool "Dynamically allocate memory in real time"
        ---help---
          This choice supports dynamic allocation of the memory
          for the receive buffer. The driver will allocate the RX buffer
          when it is required.


"MEMROY" looks suspicious. Is it a typo (MEMORY?) or by intent?

Thanks!

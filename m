Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59520 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0CBDRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 22:17:24 -0500
Received: by pwj8 with SMTP id 8so2111847pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 19:17:24 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 2 Mar 2010 12:17:24 +0900
Message-ID: <ffa0ad881003011917i6943b91cm3e3682c8ca0b8d3e@mail.gmail.com>
Subject: About libertas spi driver
From: Soohyung Cho <celius202@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

We developed a s3c2442-based custom board and
it has WM-G-MR-09 wireless lan chip connected with spi interface.

I added spi_register_board_info to our mach-xxx.c like cm-x270.c
and I included libertas spi modules.

When the board starts, if_spi_init_module function is called but
if_spi_probe function is never called.

Do I miss something?
Any help will be appreciated.

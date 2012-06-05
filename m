Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34291 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab2FECxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 22:53:43 -0400
Received: by bkcji2 with SMTP id ji2so4193690bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jun 2012 19:53:41 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 Jun 2012 10:53:41 +0800
Message-ID: <CALx5=V8gS-FudA0EAmoEs=xwQ7hr_BntO4Jr_+6tR9pYSNDUdg@mail.gmail.com> (sfid-20120605_045346_656263_57F140A7)
Subject: Connected standby support ?
From: Matt Chen <mattsled@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, users@rt2x00.serialmonkey.com
Cc: joeyli <jlee@suse.com>, Michael Chang <mchang@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,
As the incoming UEFI new design for BIOS, Microsoft has already
provided a model, "connected standby",  for power management. There
are 3 modes which are S0, Low Power S0 and S5.
I am wondering if there is already any support for the connected
standby in wifi of Linux ?

-- 
Thank you.

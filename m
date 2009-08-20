Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:4699 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZHTPk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 11:40:58 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1784550qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 08:40:59 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 20 Aug 2009 08:40:59 -0700
Message-ID: <8f3763990908200840p28cd6792qa16393dbbbe87e83@mail.gmail.com>
Subject: Re: ath9k broken in 2.6.31-rc6
From: ASIC Felix <ic.felix@gmail.com>
To: tmb-4qZELD6Fgxhg9hUCZPvPmw@public.gmane.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Thomas,

your log shows "klogd: AR_INTR_SYNC_LOCAL_TIMEOUT",
since "master-2009-08-14" I no longer see it in dmesg, I don't know
with patch fixed it.

Perhaps you want to do a quick test with different dates of
compat-wireless, it now allows compiling Atheros drivers only which
makes it much quicker.

I assume you prepare wlan including ath9k for Mandriva kernels?

(disclaimer: I'm not a driver developer)

Best regards,
Felix

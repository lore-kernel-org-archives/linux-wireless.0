Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:36841 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbbINO4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 10:56:45 -0400
Received: by qgx61 with SMTP id 61so117010184qgx.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 07:56:44 -0700 (PDT)
Received: from ?IPv6:2001:48f8:22:9a9::6? ([2001:48f8:22:9a9::6])
        by smtp.googlemail.com with ESMTPSA id c188sm6016321qka.37.2015.09.14.07.56.43
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2015 07:56:44 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: rhubarbpieguy@gmail.com
Subject: Firmware works only if kernel source drivers are built as modules.
Message-ID: <55F6E028.9010809@gmail.com> (sfid-20150914_165649_091406_77B462AD)
Date: Mon, 14 Sep 2015 09:56:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I'm attempting to load iwlwifi-3160 firmware.  It works only if I build 
the following drivers as modules.

     Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate

      Intel Wireless WiFi MVM Firmware Support

If I compile them into the kernel the firmware is not found.  This is my 
first experience with firmware.  Does firmware require drivers built as 
modules?  I see nothing at 
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi stating 
modules must be used.

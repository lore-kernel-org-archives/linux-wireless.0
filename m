Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:33372 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbbEPTwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 15:52:51 -0400
Received: by lagr1 with SMTP id r1so86164122lag.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 12:52:49 -0700 (PDT)
Received: from [192.168.0.103] ([213.21.44.132])
        by mx.google.com with ESMTPSA id ml10sm1356982lbc.29.2015.05.16.12.52.48
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2015 12:52:48 -0700 (PDT)
Message-ID: <5557A00E.1090104@users.sourceforge.net> (sfid-20150516_215449_156821_6CD399F8)
Date: Sat, 16 May 2015 22:52:46 +0300
From: Alberto Mardegan <mardy@users.sourceforge.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: tp-link tl-wn8200nd and rtlwifi_new drivers
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all!
   I unfortunately purchased a Tp-Link TL-WN8200ND USB wireless adapter, 
which is not working in Linux (there are several reports of this in this 
ML already, so I won't bother you with another one).

I wanted to test the new rtlwifi_new drivers from
   https://github.com/lwfinger/rtlwifi_new
to see if by any chance they could help having this device running. I 
built then and installed them (in Ubuntu 14.04), but I don't know how to 
make sure that the kernel is using the new drivers and not the old ones.
Is there some hint in the syslog which could tell me whether I'm now 
using the new or the old drivers (for the record, it still doesn't work)?

Ciao,
   Alberto

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48534 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1CPOfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 10:35:30 -0400
Received: by fxm17 with SMTP id 17so1715353fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 07:35:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTima9_VSL4Db1RXSPLRXyoBOwdym9CkJUJrySnSC@mail.gmail.com>
References: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
	<1300284739-7797-2-git-send-email-lemenkov@gmail.com>
	<AANLkTima9_VSL4Db1RXSPLRXyoBOwdym9CkJUJrySnSC@mail.gmail.com>
Date: Wed, 16 Mar 2011 17:33:09 +0300
Message-ID: <AANLkTikCxK144u8mMtOFjXK6qRMmb1+eE1gLuYnbMB_A@mail.gmail.com>
Subject: Re: [PATCH 1/4] rt2x00: Add rt2870 device id
From: Peter Lemenkov <lemenkov@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/16 Rafał Miłecki <zajec5@gmail.com>:
> 2011/3/16 Peter Lemenkov <lemenkov@gmail.com>:
>> Add ID for Asus USB-N11 Wi-FI adapter. Tested by me.
>>
>> Signed-off-by: Peter Lemenkov <lemenkov@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
> Either: the patch or title seems to be incorrect. It looks like you
> just moved place where entry was typed...?

Yes, it is intended. This device was enlisted under
CONFIG_RT2800USB_UNKNOWN previously (nobody was aware whether it works
with this driver or not). Now I can confirm that it does work fine.


-- 
With best regards, Peter Lemenkov.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37591 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1HZNnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:43:01 -0400
Received: by ewy4 with SMTP id 4so1488432ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 06:42:59 -0700 (PDT)
Subject: How to write a period CF-Poll sending program in mac80211
From: pangyunong <029012@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 21:41:06 +0800
Message-ID: <1314366066.3030.18.camel@Yunong> (sfid-20110826_154310_854804_339B270B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I want to write implement PCF in mac80211 below Atheros ath9k Driver
which has no PCF support now. So I must periodic send CF-Poll + [DATA]
after sending a Beacon and set up the response for PCF in STA.

I think I should know, 

    1. How to setup a timer to count for this PCF period and CF-Poll
period. How to deal with that timer interrupt. 

    2. How to create a poll table to poll those associated STAs.

Can you give me some examples or point out which part I should learn so
that I can implement those PCF mechanism in mac80211?



Yunong Pang
Regards,


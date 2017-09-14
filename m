Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:46468 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdINTor (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 15:44:47 -0400
Received: by mail-lf0-f54.google.com with SMTP id m199so392495lfe.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 12:44:46 -0700 (PDT)
Received: from [172.28.2.212] (static-213-115-247-2.sme.bredbandsbolaget.se. [213.115.247.2])
        by smtp.gmail.com with ESMTPSA id x28sm1280289lje.30.2017.09.14.12.44.44
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Sep 2017 12:44:44 -0700 (PDT)
From: Joel B <maxxflow@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi: ToF usage
Message-ID: <981d5fb9-4c3f-be8e-265a-6d21a2591e40@maxxflow.com> (sfid-20170914_214450_543811_977A8C9B)
Date: Thu, 14 Sep 2017 21:44:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Starting to play around with the FTM/ToF support in iwlwifi, but 
documentation is (understandably) scarce at this point. Using a pair of 
8260:s I had lying around.

Can someone give me some hints on how to work the debugfs API for a 
successful measurement?

I've set up one card as AP with hostapd (with ftm_responder=1 and 
ftm_initiator=1 in hostapd.conf), the other as a STA.

 From the STA, I've played with 'tof_range_request' in debugfs. Writing 
send_range_request=1, which it doesn't choke on or anything, but nothing 
seems to happen. Guess I need to set things up a bit first, but how?

If it's possible to get this to work at all at this stage, some hints on 
how to do it would be great.


Thanks,
Joel

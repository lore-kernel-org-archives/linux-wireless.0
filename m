Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36697 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbcCCOeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 09:34:46 -0500
Received: by mail-wm0-f52.google.com with SMTP id n186so134479378wmn.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 06:34:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457015372.2044.6.camel@sipsolutions.net>
References: <1456238615-832-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1457015372.2044.6.camel@sipsolutions.net>
Date: Thu, 3 Mar 2016 15:34:44 +0100
Message-ID: <CAA2SeNJehrGzQCC7OE29nXk+LGKoVNG4r6=ueewYxsk08OwrvA@mail.gmail.com> (sfid-20160303_153529_266005_CCCAB884)
Subject: Re: [PATCHv2] mac80211: parse VHT info in injected frames
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2016-02-23 at 15:43 +0100, Lorenzo Bianconi wrote:
>> Add VHT radiotap parsing support to ieee80211_parse_tx_radiotap().
>> That capability has been tested using a d-link dir-860l rev b1
>> running OpenWrt trunk and mt76 driver
>>
> Applied. In case you didn't see, Sven sent a patch to fix the other
> docs.

Yes, I did not send the patch since I had seen the one sent by Sven :-)

>
> johannes

Regards,
Lorenzo


-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep

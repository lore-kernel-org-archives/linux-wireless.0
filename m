Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:35456 "EHLO
	mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbcGIQsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 12:48:33 -0400
Received: by mail-qt0-f173.google.com with SMTP id f89so35528916qtd.2
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jul 2016 09:48:32 -0700 (PDT)
MIME-Version: 1.0
From: Ken Harris <kjh@hokulea.org>
Date: Sat, 9 Jul 2016 09:41:25 -0700
Message-ID: <CAK_-F2+JrduJyWtLcLi8q4s9p4apv5bB7Dj1mTKtjgOmQ-Z2NQ@mail.gmail.com> (sfid-20160709_184950_730413_7E17D674)
Subject: WiFi testing tools
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peeps :

I'm trying to test 20 to 200 WiFi "stations" (running OpenWRT) in a warehouse.

I'd like to find some tools to gather lots of stats about each station
and access point , such as RSSI, bitrate, etc (similar to "iw $if0
station dump) and output to CSV (or JSON or YAML). It would also be
nice to track ping times and speed (like http://flent.org ).

I'm using the ath9k driver, so stats specific to the ath9k are also useful.

I'm also looking for analysis tools.

Any suggestions are appreciated.

Thanks

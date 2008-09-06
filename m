Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:49060 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYIFQc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 12:32:58 -0400
Received: by ti-out-0910.google.com with SMTP id b6so506148tic.23
        for <linux-wireless@vger.kernel.org>; Sat, 06 Sep 2008 09:32:56 -0700 (PDT)
Message-ID: <43f51f830809060932x2abb70f7u8c71ac82718ebb07@mail.gmail.com> (sfid-20080906_183302_223784_C46FA913)
Date: Sun, 7 Sep 2008 00:32:55 +0800
From: "Josh Yin" <epaulin@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: ath9k doesn't work on Ubuntu hardy 64bit
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

I have a AR5418 wireless card within Macbook pro 3rd, i have been
using Madwifi(svn-3637) which is working great.
When linux kernel 2.6.27-rc5 getting released, I decided to git ath9k
a try, but unfortunately it doesn't working for me.

My system is Ubuntu hardy 64bit, here is the log from kernel.log:

{{{

 8811 Sep  6 02:34:48 matrix kernel: [   17.279302] NET: Registered
protocol family 17
 8812 Sep  6 02:34:48 matrix kernel: [   17.318620] ath9k: 0.1
 8813 Sep  6 02:34:48 matrix kernel: [   17.318890] ath9k
0000:0b:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 8814 Sep  6 02:34:48 matrix kernel: [   17.318974] ath9k
0000:0b:00.0: setting latency timer to 64
 8815 Sep  6 02:34:48 matrix kernel: [   17.448317] phy0: Selected
rate control algorithm 'ath9k_rate_control'
....
 8885 Sep  6 02:35:16 matrix kernel: [   54.175476] ath0: authenticate
with AP 00:1b:11:a2:a6:ca
 8886 Sep  6 02:35:16 matrix kernel: [   54.175524] ath0: privacy
configuration mismatch and mixed-cell disabled - disassociate
 8887 Sep  6 02:35:16 matrix kernel: [   54.177783] ath0: authenticated
 8888 Sep  6 02:35:16 matrix kernel: [   54.177790] ath0: associate
with AP 00:1b:11:a2:a6:ca
 8889 Sep  6 02:35:16 matrix kernel: [   54.177795] ath0: mismatch in
privacy configuration and mixed-cell disabled - abort association

}}}

The router is D-Link 624+A using WPA2 for authentication, the software
I'm using to management the network is wicd,
which has no problem with Madwifi.

If you need any detail information, feel free to contract me.

Thanks!

-- 
Regards,
Josh.Yin/殷海明/A.K.A epaulin

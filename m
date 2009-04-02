Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36870 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbZDBOn5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 10:43:57 -0400
Received: by fxm2 with SMTP id 2so560935fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 02 Apr 2009 07:43:55 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 22:43:54 +0800
Message-ID: <5135d20a0904020743k1bbc824te7805bcd8d683058@mail.gmail.com> (sfid-20090402_164400_843467_44D5EF78)
Subject: the meaning of DS Parameter set current channel
From: fengzeheng <zehengfeng@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi, all
      I have a marvell chipset. It generate probe request with random
Ds parameter--current  channel. My sniffer card is working at channel
11 and capture marvell chipset's  packets. I found that marvell send
probe request with current working channel  number 2,3,6,36...., It
looks like a random number. shouldn't this parameter be set to 11 ? as
we sniffer at channel 11  so that  what we can hear should work at
channel 11.  and I capture other intel/d_link card , and their probe
request don't include this mgmt parameter.
     according ieee 802.11--2007, DS parameter set IE current  channel
parameter  indicate STA's current working channel. So I guess DS
paramter set current channel should always be 11 as marvell was
working at this channel. but it's seem ramdom. what's the meaning of
this parameter?  does chipset can set it not the same as current
working channel?  if AP recieve a probe request which has a current
channel not same as  current working channel , how to deal with it ?
     thanks
--
Best Regards
Feng zeheng

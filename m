Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:36284 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbbJGSvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 14:51:05 -0400
Received: by ykba192 with SMTP id a192so23087014ykb.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2015 11:51:04 -0700 (PDT)
MIME-Version: 1.0
From: Ramprasad Vempati <ramprasad.vempati@gmail.com>
Date: Thu, 8 Oct 2015 00:20:44 +0530
Message-ID: <CAB6w8enLcU8LZfL=Uzpi5x6od_VExUdTW2PT9norQ=8POGNFcw@mail.gmail.com> (sfid-20151007_205109_347694_FA066B23)
Subject: How to enforce Wireless Mode of Station?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been trying to find how to control wireless mode, i.e. 802.11b or
802.11g or 802.11ng or 802.11a etc for Station mode. In general for
Station mode, the connection happens with AP based AP mode. But for
test purpose, if I would like to control mode of a wireless station,
is it possible?  I mean when AP is 11bgn mode, if I want STA to
associate in 11b mode?

I understand "iw" can be used to set rate mask. But I've tried with
ath9k or intel chipsets. I've not been able to get it working as most
of the vendors didn't implement this.

Is there a different way to enforce specific wireless mode on station?

Thanks,
Ram

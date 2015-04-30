Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33063 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbbD3A5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 20:57:52 -0400
Received: by oica37 with SMTP id a37so36272520oic.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 17:57:51 -0700 (PDT)
Message-ID: <55417E0C.2010206@lwfinger.net> (sfid-20150430_025908_986124_D3923F4A)
Date: Wed, 29 Apr 2015 19:57:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Source of Reason 7 disconnects
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel and Johannes,

I am trying to fix "Reason: 7=CLASS3_FRAME_FROM_NONASSOC_STA" disconnections for 
the Realtek drivers. When I did a search for similar examples from other 
drivers, I found some forum entries for the same disconnects happening on Intel 
7260 hardware. It appears that the problem was fixed in the 3.16 timeframe. I 
looked through the iwlwifi commits from that time, but I failed to see any 
patches that appeared to be appropriate.

Do either of you happen to remember what was needed to fix the problem? So far, 
I have determined that disabling power save helps, but it is not the complete 
solution.

Thanks,

Larry

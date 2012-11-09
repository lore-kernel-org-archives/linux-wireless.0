Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48326 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2KIQOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 11:14:24 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so6123163iea.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2012 08:14:23 -0800 (PST)
Message-ID: <509D2BDC.7070805@lwfinger.net> (sfid-20121109_171427_280192_D2D7CC35)
Date: Fri, 09 Nov 2012 10:14:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, lrodriguez@atheros.com
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Richie Gress <searchfgold67899@live.com>
Subject: Problem with regulatory info
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes and Luis,

I hope you can help me with a problem that is reported in 
https://bugzilla.kernel.org/show_bug.cgi?id=46171.

The OP is unable to connect using rtl8192cu, and the only thing I see in the 
logs is that for each regulatory rule, cfg80211 reports

[10930.963561] cfg80211: Disabling freq 2484 MHz as custom regd has no rule
that fits a 20 MHz wide channel

Later in the log, cfg80211 then reports

[10931.038857] cfg80211: Ignoring regulatory request Set by core since the
driver uses its own custom regulatory domain.

Do you have any ideas on where this "custom regd" is coming from? The OP has 
installed the normal crda package on his Ubuntu/Linaro 4.6.3-1ubuntu5 system 
using kernel 3.6.

Thanks,

Larry

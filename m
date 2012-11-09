Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60897 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2KIQ0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 11:26:40 -0500
Received: by mail-bk0-f46.google.com with SMTP id jk13so1728578bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2012 08:26:39 -0800 (PST)
Message-ID: <509D2EBC.4000702@gmail.com> (sfid-20121109_172648_320528_86BB4136)
Date: Fri, 09 Nov 2012 17:26:36 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Problem with regulatory info
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> Later in the log, cfg80211 then reports
>
> [10931.038857] cfg80211: Ignoring regulatory request Set by core since the
> driver uses its own custom regulatory domain.
>
> Do you have any ideas on where this "custom regd" is coming from? The OP has
> installed the normal crda package on his Ubuntu/Linaro 4.6.3-1ubuntu5 system
> using kernel 3.6.

https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=net/wireless/reg.c;h=bcc7d7ee5a516b8263c93a2556ab079d6d369280;hb=HEAD#l1315

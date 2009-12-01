Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:43904 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZLAULH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 15:11:07 -0500
Received: by ewy7 with SMTP id 7so6240028ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 12:11:13 -0800 (PST)
Message-ID: <4B15785C.30603@lwfinger.net>
Date: Tue, 01 Dec 2009 14:11:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: htl10@users.sourceforge.net, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8187 warnings on suspend
References: <665313.63774.qm@web23102.mail.ird.yahoo.com> <200911270945.31125.herton@mandriva.com.br> <4B10110E.8030402@lwfinger.net> <200912011149.49427.herton@mandriva.com.br>
In-Reply-To: <200912011149.49427.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2009 07:49 AM, Herton Ronaldo Krzesinski wrote:
> Michael Buesch reports that his rtl8187 gives warnings on suspend
> ("queueing ieee80211 work while going to suspend" warnings), as rtl8187
> can call ieee80211_queue_delayed_work after mac80211 is suspended.
> 
> This change enhances rtl8187 led code so we can avoid queuing work after
> mac80211 is suspended: now we register a radio led and make additional
> checks to ensure led is off/on properly as mac80211 wants.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> ---

NACK. After a few minutes of a rmmod/insmod infinite loop, I go a kernel
oops. I did not capture any of the details.

Larry




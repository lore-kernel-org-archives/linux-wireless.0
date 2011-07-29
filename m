Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42831 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1G2P1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 11:27:04 -0400
Received: by fxh19 with SMTP id 19so2382959fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 08:27:03 -0700 (PDT)
Message-ID: <4E32D144.6050304@gmail.com> (sfid-20110729_172709_209159_B8526302)
Date: Fri, 29 Jul 2011 17:27:00 +0200
From: p4u <hakais@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: IBSS channel support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
This is my first mail to this list, I'm Pau from Barcelona working in 
guifi.net (wireless community)
First of all I want to say thank you guys for your amazing job :-)

Now, I have a little question. Using command "iw phy phy0 info" I can 
see that IBSS mode is only avaiable in some channels for 5ghz spectrum. 
I have been looking for information about it, but I cannot find from 
what depends if some channel can by used in IBSS mode or not. So I think 
it depends on the driver and on the regdomain, is it right?

Also I'm working in some scripts, and I need to know if a channel has 
IBSS support or not. The only way I found is with iw command, but pharse 
this data is very dirty. Furthermore I can read in the end of iw help:

"Do NOT screenscrape this tool, we don't consider its output stable."

So I need another way to get this information. Any idea?

Thank you.

-- 
./p4u


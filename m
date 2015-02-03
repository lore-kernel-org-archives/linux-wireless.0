Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:43013 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbbBCAAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 19:00:38 -0500
Received: by mail-ob0-f171.google.com with SMTP id gq1so10856278obb.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2015 16:00:38 -0800 (PST)
Message-ID: <54D00FA4.2060907@lwfinger.net> (sfid-20150203_010236_533654_DB5C5B1B)
Date: Mon, 02 Feb 2015 18:00:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ken D'Ambrosio <ken@jots.org>, linux-wireless@vger.kernel.org
Subject: Re: rtl8192ee (Thinkpad T440s)
References: <10a90ab7a6c186362f339481b531832f@webmail.jots.org>
In-Reply-To: <10a90ab7a6c186362f339481b531832f@webmail.jots.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2015 05:24 PM, Ken D'Ambrosio wrote:
> Hi, all.  Just got a new Thinkpad, and needless to say, tried to fire it up on
> the network.  Ubuntu 14.04 didn't have the driver, so I tried 14.10, which did.
> I thought I was good until I tried to connect; the laptop would see all the
> advertised WAPs, but wouldn't connect to any of them (including my security-free
> ones).  I then downloaded the 3.19 RC and tried that -- same deal.  I see a few
> extra git commits in -next; any idea if that will be of any assistance?  Is
> there anything I can dig through in my logs to help flesh out what the problem is?

Logs are always helpful. As some of us do not use Ubuntu, a kernel version as 
shown by 'uname -r' is a lot more helpful that what version of Ubuntu you are using.

Kernel 3.19-rc4 from the wireless-drivers repo contains all those commits in 
-next, and it works fine here. At this point, I have been connected for 27 hours 
with a WPA2 connection.

You can also try the repo at http://github.com/lwfinger/rtlwifi-new.git. The 
master branch should be OK. If not, try the troy branch.

Larry


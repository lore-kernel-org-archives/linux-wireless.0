Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f179.google.com ([209.85.213.179]:48641 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934547Ab3FSQf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 12:35:58 -0400
Received: by mail-ye0-f179.google.com with SMTP id r3so1855281yen.38
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jun 2013 09:35:57 -0700 (PDT)
Message-ID: <51C1DDEB.3090701@lwfinger.net> (sfid-20130619_183601_451780_4626BD28)
Date: Wed, 19 Jun 2013 11:35:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Adams <cma@cmadams.net>
CC: b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4331 deauthenticates every five minutes
References: <20130619160911.GB4784@cmadams.net>
In-Reply-To: <20130619160911.GB4784@cmadams.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 11:09 AM, Chris Adams wrote:
> I have a MacBook Pro 8,2 with the BCM4331 wireless chip.  I pulled the
> firmware (666.2, 2011-02-23 01:15:07) using b43-fwcutter, and am running
> Fedora 18 (tried up to kernel 3.9.6-200.fc18.x86_64 from updates/testing
> with the same results).
>
> My problem is that it deauthenticates from the AP every 5 minutes (it
> then immediately reconnects).  From what I've read, it looks like this
> chip is a little "different"; any ideas/suggestions to help get this
> working better?
>
> Example dmesg chunk:
>
> [  948.115374] wlan0: associated
> [ 1249.636655] wlan0: deauthenticated from 00:a0:c8:xx:xx:xx (Reason: 1)

My table shows that a "Reason 1" deauthentication is for "unspecified reasons". 
Does anyone know why these might occur?

What type of encryption are you using? If it is a re-keying type such as TKIP, 
what is the interval? You should find that on the setup page of the access point.

BTW, your mailer is set up strangely. I get your address when I do a plain 
Reply, but a Reply All from Thunderbird only got the b43-dev mailing list. I had 
to add your address manually.

I also added the linux-wireless ML to the reply as some of my questions are more 
likely to be answered there.

Larry




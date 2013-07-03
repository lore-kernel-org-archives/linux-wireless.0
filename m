Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60053 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965387Ab3GCTQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 15:16:41 -0400
Received: by mail-ie0-f174.google.com with SMTP id 9so1350534iec.33
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 12:16:41 -0700 (PDT)
Message-ID: <51D47897.3080806@lwfinger.net> (sfid-20130703_211652_774076_0355D813)
Date: Wed, 03 Jul 2013 14:16:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier <xlinuxwireless@aim.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless is not avalaible ?
References: <8D04620FE438D64-1114-7061B@webmail-va009.sysops.aol.com> <alpine.DEB.2.10.1307032001430.29512@aurora.sdinet.de> <8D046351240532F-1114-718F3@webmail-va009.sysops.aol.com>
In-Reply-To: <8D046351240532F-1114-718F3@webmail-va009.sysops.aol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2013 01:48 PM, Xavier wrote:
>
> Thanks for your answer.
>
> This is a good link, but I need compat-wireless stable for 3.2 version of Linux
> kernel.
>
> In that link, there are all for >= 3.7 Linux kernel version.
>
> Exist any site for 3.2 Linux kernel version of compat-wireless ?
>
> Thanks, see you.

You do not understand compat-wireless, now called backports.

The version listed, such as 3.7, is for the *source* of the code included. The 
package includes *all* the necessary code for it to be built on kernel 2.6.24 
*OR NEWER*. If you were to find a 3.2 version of compat-wireless, it would have 
exactly the same drivers as were released with 3.2, and there would be no reason 
for you to use it! The link you were given will work for 3.2.

Larry



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58864 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaACVap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 16:30:45 -0500
Received: by mail-pb0-f43.google.com with SMTP id rq2so16119871pbb.30
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jan 2014 13:30:44 -0800 (PST)
Message-ID: <52C72C01.4030209@lwfinger.net> (sfid-20140103_223050_950913_58C8A30A)
Date: Fri, 03 Jan 2014 15:30:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Taylor <chris.taylor@cantab.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8723ae PCI Driver update
References: <CAC94StQ0EQYDxUQR6jNLEpJjB+tpR9ue2rzesz8uT6cmRTkQ8A@mail.gmail.com>	<52C5A8DB.2090506@lwfinger.net>	<CAC94StR7qDESmMiOkrDnFjmOqbmMQNJqMd=zMnMCMZR9tPmi7Q@mail.gmail.com>	<52C5D96E.7060306@lwfinger.net> <CAC94StTgBSG927imnZi36b2jXZ4Wt_hQbQ3ceO0co6e_H49n2Q@mail.gmail.com>
In-Reply-To: <CAC94StTgBSG927imnZi36b2jXZ4Wt_hQbQ3ceO0co6e_H49n2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/03/2014 03:14 PM, Chris Taylor wrote:
> OK, I wasn't aware that it was only a Ubuntu issue. Sorry if it's
> sounded like I've criticised your work on the current driver - I
> assumed it was an issue affecting all. I've tried the 3.12.6 kernel
> but didn't notice any significant difference.
>
> Would you recommend filing a bug report with Ubuntu? If so, do you
> have any inkling where the Ubuntu devs should start looking for the
> problem?

It may not only be an issue with Ubuntu; however, I am not aware of problems 
posted elsewhere. I am also aware that Ubuntu user space has a lot more trouble 
than I see with NetworkManager on openSUSE. I doubt that the Ubuntu devs would 
do much with a bug report.

Have you tried the backports package? It has material that will be in 3.14. If 
that still has the same problem, then I would need to see whatever diagnostics 
that your system outputs. As I am not an Ubuntu user, I have no idea where it 
might be. The stuff from dmesg is a help, but not usually definitive. What 
make/model of AP are you using? Is the firmware up to date? What encryption mode 
do you use, and is it 802.11n or g?

Larry


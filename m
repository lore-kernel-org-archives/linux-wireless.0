Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40067 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaACXX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 18:23:58 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so16309595pbb.28
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jan 2014 15:23:58 -0800 (PST)
Message-ID: <52C7468B.80100@lwfinger.net> (sfid-20140104_002401_999870_250B6C5A)
Date: Fri, 03 Jan 2014 17:23:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Taylor <chris.taylor@cantab.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8723ae PCI Driver update
References: <CAC94StQ0EQYDxUQR6jNLEpJjB+tpR9ue2rzesz8uT6cmRTkQ8A@mail.gmail.com>	<52C5A8DB.2090506@lwfinger.net>	<CAC94StR7qDESmMiOkrDnFjmOqbmMQNJqMd=zMnMCMZR9tPmi7Q@mail.gmail.com>	<52C5D96E.7060306@lwfinger.net>	<CAC94StTgBSG927imnZi36b2jXZ4Wt_hQbQ3ceO0co6e_H49n2Q@mail.gmail.com>	<52C72C01.4030209@lwfinger.net> <CAC94StTSz9szzyK=k3nS_FWDAF04yEV-yxzUE5F78NpeQkiDyQ@mail.gmail.com>
In-Reply-To: <CAC94StTSz9szzyK=k3nS_FWDAF04yEV-yxzUE5F78NpeQkiDyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/03/2014 04:06 PM, Chris Taylor wrote:
> Which backports package are you referring to? I can only see a few
> listed here (http://packages.ubuntu.com/saucy-backports/).
>
> My AP is a Technicolor TG582n, latest firmware - but my Windows 8.1
> tablet has no problems connecting in locations round the house where
> my Kubuntu laptop struggles. I don't think I've got an option on the
> encryption mode - it's listed as 802.11b/g/n, which I guess means n.
>
> I've got another AP I could try somewhere - I'd not thought of trying
> that since my Windows machines seem to pick up the signal fine. But it
> might be worth a go.

If you want the latest backports code, go to 
http://drvbp1.linux-foundation.org/~mcgrof/rel-html/backports/ and get the 
latest. You will need to build it yourself. The saucy-backports package is 
probably not for wifi.

The manual for the AP says that it uses WPA2 as the default. It has 802.11n 
capability and probably is running in 802.11g+n mode.

Larry



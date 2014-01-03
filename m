Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63141 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbaACWGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 17:06:25 -0500
Received: by mail-lb0-f181.google.com with SMTP id q8so8342097lbi.26
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jan 2014 14:06:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C72C01.4030209@lwfinger.net>
References: <CAC94StQ0EQYDxUQR6jNLEpJjB+tpR9ue2rzesz8uT6cmRTkQ8A@mail.gmail.com>
	<52C5A8DB.2090506@lwfinger.net>
	<CAC94StR7qDESmMiOkrDnFjmOqbmMQNJqMd=zMnMCMZR9tPmi7Q@mail.gmail.com>
	<52C5D96E.7060306@lwfinger.net>
	<CAC94StTgBSG927imnZi36b2jXZ4Wt_hQbQ3ceO0co6e_H49n2Q@mail.gmail.com>
	<52C72C01.4030209@lwfinger.net>
Date: Fri, 3 Jan 2014 22:06:23 +0000
Message-ID: <CAC94StTSz9szzyK=k3nS_FWDAF04yEV-yxzUE5F78NpeQkiDyQ@mail.gmail.com> (sfid-20140103_230629_218136_84322DF6)
Subject: Re: RTL8723ae PCI Driver update
From: Chris Taylor <chris.taylor@cantab.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Which backports package are you referring to? I can only see a few
listed here (http://packages.ubuntu.com/saucy-backports/).

My AP is a Technicolor TG582n, latest firmware - but my Windows 8.1
tablet has no problems connecting in locations round the house where
my Kubuntu laptop struggles. I don't think I've got an option on the
encryption mode - it's listed as 802.11b/g/n, which I guess means n.

I've got another AP I could try somewhere - I'd not thought of trying
that since my Windows machines seem to pick up the signal fine. But it
might be worth a go.

Chris

On 3 January 2014 21:30, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 01/03/2014 03:14 PM, Chris Taylor wrote:
>>
>> OK, I wasn't aware that it was only a Ubuntu issue. Sorry if it's
>> sounded like I've criticised your work on the current driver - I
>> assumed it was an issue affecting all. I've tried the 3.12.6 kernel
>> but didn't notice any significant difference.
>>
>> Would you recommend filing a bug report with Ubuntu? If so, do you
>> have any inkling where the Ubuntu devs should start looking for the
>> problem?
>
>
> It may not only be an issue with Ubuntu; however, I am not aware of problems
> posted elsewhere. I am also aware that Ubuntu user space has a lot more
> trouble than I see with NetworkManager on openSUSE. I doubt that the Ubuntu
> devs would do much with a bug report.
>
> Have you tried the backports package? It has material that will be in 3.14.
> If that still has the same problem, then I would need to see whatever
> diagnostics that your system outputs. As I am not an Ubuntu user, I have no
> idea where it might be. The stuff from dmesg is a help, but not usually
> definitive. What make/model of AP are you using? Is the firmware up to date?
> What encryption mode do you use, and is it 802.11n or g?
>
> Larry
>

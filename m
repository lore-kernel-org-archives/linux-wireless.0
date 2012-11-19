Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:41832 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2KSAMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 19:12:33 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so2999854iay.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Nov 2012 16:12:32 -0800 (PST)
Message-ID: <50A9796D.5020701@lwfinger.net> (sfid-20121119_011236_458109_EB4B393F)
Date: Sun, 18 Nov 2012 18:12:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: sebastien.major@free.fr
CC: linux-wireless@vger.kernel.org
Subject: Re: Edimax EW-7612Aun does not work.
References: <1169888163.63483054.1353282853141.JavaMail.root@zimbra4-e1.priv.proxad.net>
In-Reply-To: <1169888163.63483054.1353282853141.JavaMail.root@zimbra4-e1.priv.proxad.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2012 05:54 PM, sebastien.major@free.fr wrote:
>
> Hello,
>
> All is said in title : my edimax refuse to start correctly.
>
> kernel choose to load rtl8192cu and appropriate firmware but nothing : I see a reply in dmesg which says "wlan10 : link not ready".
>
> tested on Acer laptop Core 2 duo with linux 3.6.7 freshly compiled by kpkg-buildpackage (Debian unstable).
>
> Edimax driver are old and for i386 (32 bits).
>
>
> Any doc is welcome : thanks by advance.

That problem is not likely due to rtl8192cu, but is related to some other issue. 
What does 'rfkill list' show?

What distro do you use?

Larry



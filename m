Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:59067 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab2KTCFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 21:05:50 -0500
Date: Tue, 20 Nov 2012 03:05:41 +0100 (CET)
From: sebastien.major@free.fr
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Message-ID: <92462275.65280719.1353377141011.JavaMail.root@zimbra4-e1.priv.proxad.net> (sfid-20121120_030555_318873_B52272A2)
In-Reply-To: <1704475029.63506299.1353285839059.JavaMail.root@zimbra4-e1.priv.proxad.net>
Subject: Apologies ... Re: Edimax EW-7612Aun does not work.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

>First of all : many thanks for you done with Linux !!!
First of all : many thanks for all you done with Linux !!! And probably more, many thanks to take time for answered me too.

In fact, you were completely right : it's a distro issue.

I choose a last 3.6.7 stable kernel and it _works_ properly.
I think I forgot "ifconfig wlan0 up" and unstable debian distro is out.
Sorry for my disturb of your work.

Need to install one other similar wifi card : netgear WMA3100M and hope to get rid of ndiswrapper.

Best regards.
S. Major


----- Mail original -----
De: "sebastien major" <sebastien.major@free.fr>
À: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Envoyé: Lundi 19 Novembre 2012 01:43:59
Objet: Re: Edimax EW-7612Aun does not work.


Hello,

First of all : many thanks for you done with Linux !!!
Ok.

I traced rfkill, iwconfig wlan0, uname -a, dmesg, lsusb and lsusb -v.

Best regards.
S. Major

Here it is : 

===> # rfkill
0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no

I use debian unstable (updated last thursday).

Here some other traces :

===> # dmesg

[...]

===> That's all.

----- Mail original -----
De: "Larry Finger" <Larry.Finger@lwfinger.net>
À: "sebastien major" <sebastien.major@free.fr>
Cc: linux-wireless@vger.kernel.org
Envoyé: Lundi 19 Novembre 2012 01:12:29
Objet: Re: Edimax EW-7612Aun does not work.

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


--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

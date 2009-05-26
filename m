Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39022 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753278AbZEZQXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 12:23:08 -0400
Message-ID: <4A1C1766.3030004@gmx.net>
Date: Tue, 26 May 2009 18:23:02 +0200
From: Barkle <barkle@gmx.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL 8185
References: <4A199FED.7000609@gmx.net>	 <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>	 <4A1B00E7.5070801@gmx.net>	 <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>	 <4A1B2186.3070107@gmx.net> <3ace41890905252258p54d858b0qfc172284cb65423f@mail.gmail.com>
In-Reply-To: <3ace41890905252258p54d858b0qfc172284cb65423f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung schrieb:
> I am asking to a 2nd time - try compat-wireless.

When I compile compat-wireless, I get an error

*************************
feta:/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6# uname -r
2.6.30-rc6-1
feta:/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6# make
make -C /lib/modules/2.6.30-rc6-1/build 
M=/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6 modules
make[1]: Entering directory `/usr/src/linux-2.6.30-rc6'
  CC [M]  
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.o
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c: 
In function 'ieee80211_led_init':
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:58: 
error: invalid application of 'sizeof' to incomplete type 'struct 
led_trigger'
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:62: 
error: dereferencing pointer to incomplete type
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:63: 
error: implicit declaration of function 'led_trigger_register'
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:69: 
error: invalid application of 'sizeof' to incomplete type 'struct 
led_trigger'
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:73: 
error: dereferencing pointer to incomplete type
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:80: 
error: invalid application of 'sizeof' to incomplete type 'struct 
led_trigger'
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:84: 
error: dereferencing pointer to incomplete type
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:91: 
error: invalid application of 'sizeof' to incomplete type 'struct 
led_trigger'
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:95: 
error: dereferencing pointer to incomplete type
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c: 
In function 'ieee80211_led_exit':
/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.c:106: 
error: implicit declaration of function 'led_trigger_unregister'
make[3]: *** 
[/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211/led.o] 
Fehler 1
make[2]: *** 
[/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6/net/mac80211] 
Fehler 2
make[1]: *** 
[_module_/usr/src/tools/compat-wireless/compat-wireless-2.6.30-rc6] Fehler 2
make[1]: Leaving directory `/usr/src/linux-2.6.30-rc6'
make: *** [modules] Fehler 2
*************************

Also with the bleeding edge I get the same error

*************************
feta:/usr/src/tools/compat-wireless/compat-wireless-2009-05-26# uname -r
2.6.30-rc6-1
feta:/usr/src/tools/compat-wireless/compat-wireless-2009-05-26# make
make -C /lib/modules/2.6.30-rc6-1/build 
M=/usr/src/tools/compat-wireless/compat-wireless-2009-05-26 modules
make[1]: Entering directory `/usr/src/linux-2.6.30-rc6'
  CC [M]  
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.o
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c: 
In function 'ieee80211_led_init':
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:58: 
error: invalid application of 'sizeof' to incomplete type 'struct 
led_trigger'
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:62: 
error: dereferencing pointer to incomplete type
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:63: 
error: implicit declaration of function 'led_trigger_register'
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:69: 
error: invalid application of 'sizeof' to incomplete type 'struct 
led_trigger'
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:73: 
error: dereferencing pointer to incomplete type
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:80: 
error: invalid application of 'sizeof' to incomplete type 'struct 
led_trigger'
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:84: 
error: dereferencing pointer to incomplete type
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:91: 
error: invalid application of 'sizeof' to incomplete type 'struct 
led_trigger'
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:95: 
error: dereferencing pointer to incomplete type
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c: 
In function 'ieee80211_led_exit':
/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.c:106: 
error: implicit declaration of function 'led_trigger_unregister'
make[3]: *** 
[/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211/led.o] 
Fehler 1
make[2]: *** 
[/usr/src/tools/compat-wireless/compat-wireless-2009-05-26/net/mac80211] 
Fehler 2
make[1]: *** 
[_module_/usr/src/tools/compat-wireless/compat-wireless-2009-05-26] Fehler 2
make[1]: Leaving directory `/usr/src/linux-2.6.30-rc6'
make: *** [modules] Fehler 2
*************************


> Since you have a 32-bit intel CPU, if you don't mind downgrade the
> kernel back to about 2.6.26 or 2.6.24,

This would be one of my last favorites.


> you might consider switching to the realtek vendor driver. It is a bit ugly but it works well enough
> with older kernels on 32-bit intel platforms. The code is on realtek's
> web site.
> http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=1&PFid=1&Level=6&Conn=5&DownTypeID=3&GetDown=false&Downloads=true
>   
Hmm, later ... may be.

> You also have the choice of using ndiswrapper, on 32-bit intel platforms.
>   

No this is no optinion, because the windows-driver is not as stable as I 
want.




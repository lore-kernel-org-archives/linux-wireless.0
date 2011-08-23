Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59575 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1HWKxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 06:53:45 -0400
Received: by wwf5 with SMTP id 5so6113413wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 03:53:44 -0700 (PDT)
Date: Tue, 23 Aug 2011 12:53:41 +0200
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
Message-ID: <20110823105341.GA5604@stt008.linux.site> (sfid-20110823_125415_339660_C0A7F247)
References: <20110822112737.GA5936@stt008.linux.site> <4E525235.7060501@broadcom.com> <CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com> <4E525FC7.4070802@broadcom.com> <CAKprTDF0iFSAkYZiLQFLX+KumyLbzNUvHocKJyzK37Kv_79EFA@mail.gmail.com> <4E5367AA.8040406@broadcom.com> <CAKprTDFret5n-AH_B_Hu6E0+B4FEGJQ=jjYbGNy8ZD5R8ReFCg@mail.gmail.com> <4E53728B.3030803@broadcom.com> <20110823095348.GA5383@stt008.linux.site> <4E538309.1040203@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4E538309.1040203@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 2011-08-23 a las 12:38 +0200, Roland Vossen escribió:

> Hi Camaleón,
>
> > Done. It gets stuck when issuing "iw wlan0 scan". I mean, I get no
> > output, just a blinking cursor as is the task it is being running but
> > returns nothing and logs (dmesg and /var/log/syslog) show nothing
> > relevant.
>
> that sounds like a kernel thread never exiting the brcmsmac driver.  
> Which means we have to add debug messages (printk) to the driver or hook  
> up a debugger.
>
> Would you be able/willing to make debug related changes to our driver  
> and build it ? I can tell you what changes to make.

I can try whataver you want me to try :-)

Just provide some guidance on what are the required steps.

Greetings,

-- 
Camaleón 

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65481 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1HWJxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 05:53:52 -0400
Received: by wyg24 with SMTP id 24so4063188wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 02:53:51 -0700 (PDT)
Date: Tue, 23 Aug 2011 11:53:48 +0200
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
Message-ID: <20110823095348.GA5383@stt008.linux.site> (sfid-20110823_115356_114340_376906C9)
References: <CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com> <4E52297D.9090301@broadcom.com> <20110822112737.GA5936@stt008.linux.site> <4E525235.7060501@broadcom.com> <CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com> <4E525FC7.4070802@broadcom.com> <CAKprTDF0iFSAkYZiLQFLX+KumyLbzNUvHocKJyzK37Kv_79EFA@mail.gmail.com> <4E5367AA.8040406@broadcom.com> <CAKprTDFret5n-AH_B_Hu6E0+B4FEGJQ=jjYbGNy8ZD5R8ReFCg@mail.gmail.com> <4E53728B.3030803@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4E53728B.3030803@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 2011-08-23 a las 11:27 +0200, Roland Vossen escribió:

> Hello Camaleón,
>
> I did not see anything unusual in the provided 'ps -A' output.
>
> I want to find out what the result of a scan is, specifically the RSSI.  
> In that way I can judge if this is a signal reception problem.
>
> Can you do the following:
>
> - unload brcmsmac driver (or simply don't load it)
> - 'sudo service network-manager stop'
> 	.. this gets network-manager out of the way, perhaps it is related to  
> the 'resource/device busy' message
> - load driver
> - 'sudo ifconfig wlan0 up'
> - 'sudo iw wlan0 scan'

Done. It gets stuck when issuing "iw wlan0 scan". I mean, I get no 
output, just a blinking cursor as is the task it is being running but 
returns nothing and logs (dmesg and /var/log/syslog) show nothing 
relevant.

Greetings,

-- 
Camaleón 

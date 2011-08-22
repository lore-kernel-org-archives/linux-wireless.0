Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43092 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1HVO1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 10:27:18 -0400
Received: by ewy4 with SMTP id 4so1861905ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 07:27:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E525FC7.4070802@broadcom.com>
References: <20110814121646.GA5188@stt008.linux.site>
	<4E4A5641.4020604@broadcom.com>
	<1313509211.2065.36.camel@dcbw.foobar.com>
	<4E4B9A45.5090507@broadcom.com>
	<4E4CC85A.7010504@broadcom.com>
	<4E4E73F4.4040105@broadcom.com>
	<20110819152140.GA7506@stt008.linux.site>
	<CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com>
	<4E52297D.9090301@broadcom.com>
	<20110822112737.GA5936@stt008.linux.site>
	<4E525235.7060501@broadcom.com>
	<CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com>
	<4E525FC7.4070802@broadcom.com>
Date: Mon, 22 Aug 2011 16:27:17 +0200
Message-ID: <CAKprTDF0iFSAkYZiLQFLX+KumyLbzNUvHocKJyzK37Kv_79EFA@mail.gmail.com> (sfid-20110822_162722_397578_6A495EF7)
Subject: Re: brcmsmac driver only works when sitting next to the AP
From: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/22 Roland Vossen <rvossen@broadcom.com>:
> Hi Camaleón,
>
>> I blackisted the module:
>>
>> root@stt300:~# grep -i blue /etc/modprobe.d/blacklist.conf
>> blacklist bluetooth
>>
>> And rebooted. Now I can't see the module loaded:
>>
>> root@stt300:~# lsmod|grep blu
>> root@stt300:~#
>>
>> Bu I still get the same issue:
>
> so neither RF Kill nor Bluetooth seems to be related to the issue.
>
> Lets look at the scan results (if any). Can you note the name of the
> wireless interface (wlan0, wlan1, ...) and issue a:
>
> $ iw wlan0 scan

root@stt300:~# iw wlan0 scan
command failed: Device or resource busy (-16)

Greetings,

-- 
Camaleón

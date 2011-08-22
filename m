Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4495 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1HVNzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 09:55:41 -0400
Message-ID: <4E525FC7.4070802@broadcom.com> (sfid-20110822_155556_188001_97CC4736)
Date: Mon, 22 Aug 2011 15:55:19 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
References: <20110814121646.GA5188@stt008.linux.site>
 <4E4A5641.4020604@broadcom.com>
 <1313509211.2065.36.camel@dcbw.foobar.com>
 <4E4B9A45.5090507@broadcom.com> <4E4CC85A.7010504@broadcom.com>
 <4E4E73F4.4040105@broadcom.com>
 <20110819152140.GA7506@stt008.linux.site>
 <CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com>
 <4E52297D.9090301@broadcom.com>
 <20110822112737.GA5936@stt008.linux.site>
 <4E525235.7060501@broadcom.com>
 <CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com>
In-Reply-To: <CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Camaleón,

 > I blackisted the module:
 >
 > root@stt300:~# grep -i blue /etc/modprobe.d/blacklist.conf
 > blacklist bluetooth
 >
 > And rebooted. Now I can't see the module loaded:
 >
 > root@stt300:~# lsmod|grep blu
 > root@stt300:~#
 >
 > Bu I still get the same issue:

so neither RF Kill nor Bluetooth seems to be related to the issue.

Lets look at the scan results (if any). Can you note the name of the 
wireless interface (wlan0, wlan1, ...) and issue a:

$ iw wlan0 scan

Thanks, Roland.


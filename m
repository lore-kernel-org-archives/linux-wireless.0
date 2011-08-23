Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1143 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1HWKiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 06:38:19 -0400
Message-ID: <4E538309.1040203@broadcom.com> (sfid-20110823_123825_200845_52D473BD)
Date: Tue, 23 Aug 2011 12:38:01 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
References: <CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com>
 <4E52297D.9090301@broadcom.com>
 <20110822112737.GA5936@stt008.linux.site>
 <4E525235.7060501@broadcom.com>
 <CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com>
 <4E525FC7.4070802@broadcom.com>
 <CAKprTDF0iFSAkYZiLQFLX+KumyLbzNUvHocKJyzK37Kv_79EFA@mail.gmail.com>
 <4E5367AA.8040406@broadcom.com>
 <CAKprTDFret5n-AH_B_Hu6E0+B4FEGJQ=jjYbGNy8ZD5R8ReFCg@mail.gmail.com>
 <4E53728B.3030803@broadcom.com>
 <20110823095348.GA5383@stt008.linux.site>
In-Reply-To: <20110823095348.GA5383@stt008.linux.site>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Camaleón,

 > Done. It gets stuck when issuing "iw wlan0 scan". I mean, I get no
 > output, just a blinking cursor as is the task it is being running but
 > returns nothing and logs (dmesg and /var/log/syslog) show nothing
 > relevant.

that sounds like a kernel thread never exiting the brcmsmac driver. 
Which means we have to add debug messages (printk) to the driver or hook 
up a debugger.

Would you be able/willing to make debug related changes to our driver 
and build it ? I can tell you what changes to make.

Thanks, Roland.


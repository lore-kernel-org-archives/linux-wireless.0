Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1282 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1HWIl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:41:26 -0400
Message-ID: <4E5367AA.8040406@broadcom.com> (sfid-20110823_104129_380739_6C9BC832)
Date: Tue, 23 Aug 2011 10:41:14 +0200
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
 <4E525FC7.4070802@broadcom.com>
 <CAKprTDF0iFSAkYZiLQFLX+KumyLbzNUvHocKJyzK37Kv_79EFA@mail.gmail.com>
In-Reply-To: <CAKprTDF0iFSAkYZiLQFLX+KumyLbzNUvHocKJyzK37Kv_79EFA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Camaleón,

 >> $ iw wlan0 scan
 >
 > root@stt300:~# iw wlan0 scan
 > command failed: Device or resource busy (-16)

couple more requests:

can you send me the output of 'sudo ps -A' ?

can you issue a '$ iwlist channel' and a '$ iwlist scanning' ?

Thanks, Roland.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3870 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab2GQHyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 03:54:38 -0400
Message-ID: <50051A2F.3030206@broadcom.com> (sfid-20120717_095442_327130_CBA3A4AB)
Date: Tue, 17 Jul 2012 09:54:23 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: linux-wireless@vger.kernel.org,
	=?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"Stanislaw Gruszka" <sgruszka@redhat.com>,
	"Seth Forshee" <seth.forshee@canonical.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
References: <CAKprTDGtvUFSBb_XK01bi6bJa3dynu73Lq-jTs=E78E3QwSqpA@mail.gmail.com>
 <20120601174237.GA31781@burratino>
 <CAKprTDHepfbCKquvnG8CQ2=-tSNbgOSkT6R0GQmEx9UyuiZyMQ@mail.gmail.com>
 <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino> <4FE0CA49.3030909@broadcom.com>
 <20120716213122.GA3078@burratino>
In-Reply-To: <20120716213122.GA3078@burratino>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2012 11:31 PM, Jonathan Nieder wrote:
> 
> With all the above patches applied on top of 3.2.21, Camaleón quickly
> gets the reconnects and gnome-shell segfaults if she does not supply
> the password to network-manager in time[1].  That means the patch that
> prevents trouble is presumably one of the four listed below.
> 
>>>   137dabed34a1 brcm80211: smac: remove smatch warnings from brcmsmac code
>>>   2b0a53d51b5f brcm80211: smac: only print block-ack timeout message at
>>>                trace level
>>>   6b8da423315b brcm80211: smac: do not use US as fallback regulatory hint
>>>   94a2ca311cf4 brcm80211: smac: only provide valid regulatory hint
> 
> Thanks,
> Jonathan
> 
> [1] http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=295;bug=664767
> 

Thanks, Jonathan

I guess the behaviour improved due to the last two patches listed above,
but I also suspect that it is only an improvement and the root cause
still exists.

Gr. AvS


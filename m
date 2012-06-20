Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4682 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab2FTHMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:12:13 -0400
Message-ID: <4FE177BC.5020106@broadcom.com> (sfid-20120620_091215_757373_20A671A4)
Date: Wed, 20 Jun 2012 09:11:56 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: "Stanislaw Gruszka" <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	=?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"Seth Forshee" <seth.forshee@canonical.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
References: <20120601174237.GA31781@burratino>
 <CAKprTDHepfbCKquvnG8CQ2=-tSNbgOSkT6R0GQmEx9UyuiZyMQ@mail.gmail.com>
 <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino> <20120619181522.GB19354@burratino>
 <4FE0CFD4.4000300@broadcom.com> <20120619192818.GA19971@burratino>
In-Reply-To: <20120619192818.GA19971@burratino>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2012 09:28 PM, Jonathan Nieder wrote:
> Arend van Spriel wrote:
>> However, I still observe the warning so I am looking what other event
>> trigger this issue.
> 
> Feel free to contact Touko Korpela <touko.korpela@iki.fi> and Camaleón
> if you need recent logs or other information about that[1].
> 
> I had been hoping that was mostly orthogonal until Camaleón mentioned
> that 3.2.2 doesn't seem to trigger the random reconnects.

I missed this piece of info. So the following statements are true?

1. v3.2.2 and earlier did not show the issue.
2. v3.2.9 until 3.2.17 have random reconnects.
3. v3.2.18 does not have random reconnects (or less).

Unfortunately, between v3.2.2 and v3.2.9 the only commit was the
infinite loop fix from Stanislaw so that does not solve the puzzle.
It only bails out with a warning, but there probably still is a problem
in v3.2.2.

Gr. AvS


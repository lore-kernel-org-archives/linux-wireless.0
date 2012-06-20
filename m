Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3683 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab2FTMN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 08:13:26 -0400
Message-ID: <4FE1BE5A.2060808@broadcom.com> (sfid-20120620_141330_124393_B646F15C)
Date: Wed, 20 Jun 2012 14:13:14 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: "Stanislaw Gruszka" <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	=?windows-1252?Q?Camale=F3n?= <noelamac@gmail.com>,
	"Seth Forshee" <seth.forshee@canonical.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
References: <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino> <20120619181522.GB19354@burratino>
 <4FE0CFD4.4000300@broadcom.com> <20120619192818.GA19971@burratino>
 <4FE177BC.5020106@broadcom.com> <20120620100218.GA4579@burratino>
In-Reply-To: <20120620100218.GA4579@burratino>
Content-Type: text/plain;
 charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2012 12:02 PM, Jonathan Nieder wrote:
> Arend van Spriel wrote:
>> On 06/19/2012 09:28 PM, Jonathan Nieder wrote:
> 
>>> I had been hoping that was mostly orthogonal until Camaleón mentioned
>>> that 3.2.2 doesn't seem to trigger the random reconnects.
>>
>> I missed this piece of info. So the following statements are true?
>>
>> 1. v3.2.2 and earlier did not show the issue.
>> 2. v3.2.9 until 3.2.17 have random reconnects.
>> 3. v3.2.18 does not have random reconnects (or less).
> 
> (1) and (2) are true.  I don't think (3) is.
> 

I have my doubts on (3) as well, but I think the likelihood of the
random reconnects has reduced by earlier mentioned patches. I will work
with Camaleón and/or Touko Korpela investigating this (and keep you posted).

Gr. AvS


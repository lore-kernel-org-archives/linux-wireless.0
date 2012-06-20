Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34971 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2FTKC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 06:02:27 -0400
Received: by gglu4 with SMTP id u4so5461190ggl.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 03:02:27 -0700 (PDT)
Date: Wed, 20 Jun 2012 05:02:18 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
Message-ID: <20120620100218.GA4579@burratino> (sfid-20120620_120231_563496_213AA6C0)
References: <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino>
 <20120619181522.GB19354@burratino>
 <4FE0CFD4.4000300@broadcom.com>
 <20120619192818.GA19971@burratino>
 <4FE177BC.5020106@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4FE177BC.5020106@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel wrote:
> On 06/19/2012 09:28 PM, Jonathan Nieder wrote:

>> I had been hoping that was mostly orthogonal until Camaleón mentioned
>> that 3.2.2 doesn't seem to trigger the random reconnects.
>
> I missed this piece of info. So the following statements are true?
>
> 1. v3.2.2 and earlier did not show the issue.
> 2. v3.2.9 until 3.2.17 have random reconnects.
> 3. v3.2.18 does not have random reconnects (or less).

(1) and (2) are true.  I don't think (3) is.

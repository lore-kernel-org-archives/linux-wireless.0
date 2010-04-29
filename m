Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37315 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab0D3Uiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 16:38:46 -0400
Received: by vws19 with SMTP id 19so551084vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Apr 2010 13:38:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100420113505.GJ5288@lundinova.se>
References: <20100331191058.GD18913@lundinova.se>
	 <20100416104850.GA13329@lundinova.se>
	 <20100420082519.GB5288@lundinova.se>
	 <1271754651.14253.112.camel@ranga-desktop>
	 <20100420110657.GH5288@lundinova.se>
	 <20100420113505.GJ5288@lundinova.se>
Date: Thu, 29 Apr 2010 16:26:22 +0800
Message-ID: <m2s8247263b1004290126u8894b801w4d43a78334a11633@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: corrupt frames forwarded to mac80211 as
	decrypted
From: Daniel Yingqiang Ma <yma.cool@gmail.com>
To: Johan Hovold <johan.hovold@lundinova.se>
Cc: Ranga Rao Ravuri <ranga.ravuri@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch indeed improve the link quality of my AP powered by ath9k.

It seems there are plenty of this kind of corruptted packet. Any one
know it's reason?

Thanks,
Daniel

2010/4/20 Johan Hovold <johan.hovold@lundinova.se>:
> On Tue, Apr 20, 2010 at 01:06:57PM +0200, Johan Hovold wrote:
>> On Tue, Apr 20, 2010 at 02:40:51PM +0530, Ranga Rao Ravuri wrote:
>> > Can you please set register 0x8120 bit 28 to 1 and test this again to
>> > see that helps ?
>>
>> I'll try that.
>
> I'm afraid it does not seem to have any effect on the corrupt frame
> status.
>
> Anything else I can try?
>
> Thanks,
> Johan
>
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>

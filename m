Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:33210 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZJPROC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 13:14:02 -0400
Received: by ewy4 with SMTP id 4so1805717ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 10:14:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255704382.4095.340.camel@johannes.local>
References: <1255658961.23827.2.camel@el8pc>
	 <1255704382.4095.340.camel@johannes.local>
Date: Fri, 16 Oct 2009 19:14:04 +0200
Message-ID: <8753c5d10910161014u2d8bd65fj9f24ddc436902d58@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fixed injection in monitor mode
From: MatriX <matrix.use.linux@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

why is wrong?
there's another way to inject once packet?

2009/10/16, Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2009-10-16 at 04:09 +0200, Gabriele Gristina wrote:
>> I have a problem with mac80211 injection:
>> if i setup interface in monitor mode with iwconfig and i try to send a
>> custum 802.11 frame i see twice the packet in monitor interface.
>> The first packet is right, the second is different only in the radiotap
>> header: rtap len is fixed to 13 bytes...
>> If i setup interface with airmon-ng the packet is sended once but the
>> radiotap header is fixed to 13 bytes.
>
> This is correct. The patch is wrong.
>
> johannes
>

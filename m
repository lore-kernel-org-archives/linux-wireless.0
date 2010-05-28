Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:35755 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab0E1Rmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 13:42:35 -0400
Received: by pxi18 with SMTP id 18so641656pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 May 2010 10:42:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFF9D8E.5040702@itwm.fraunhofer.de>
References: <4BFE4124.2090601@itwm.fraunhofer.de> <1274957276.4706.4.camel@aeonflux.t-mobile.de>
	<4BFF9D8E.5040702@itwm.fraunhofer.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 28 May 2010 10:42:14 -0700
Message-ID: <AANLkTin6B6EHaTzepktDo_TrRF3n0N8ZyUB9oszdE5wS@mail.gmail.com>
Subject: Re: new bluetooth id for lenovo T410s?
To: Martin Vogt <martin.vogt@itwm.fraunhofer.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 28, 2010 at 3:40 AM, Martin Vogt
<martin.vogt@itwm.fraunhofer.de> wrote:
> Marcel Holtmann wrote:
>> Hi Martin,
>>
>> so first of all, this is the wrong mailing list. You should be using
>> linux-bluetooth@vger.kernel.org.
> Oh, ok.
>
>> Please send in the output of /proc/bus/usb/devices for your devices
>> since I doubt it is not supported. There are general interface
>> descriptors that make the devices work. Only if Lenovo screwed something
>> up, then this is needed.
>>
>
> Just a small update: It works now, the btusb driver
> from the compat-wireless module didnt load with symbol
> problems.
> (I use a Suse 2.6.27 vendor kernel which already is a bit 2.6.28+
> compat-wireless-2.6.34)
>
> I placed some #if 0 #endif combinations in compat-2.6.28.c
> ==>now it works.

Was this a Suse distribution problem? If so can you elaborate?

  Luis

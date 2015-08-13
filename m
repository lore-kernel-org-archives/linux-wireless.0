Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33293 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbbHMUok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 16:44:40 -0400
Received: by obbhe7 with SMTP id he7so46656746obb.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 13:44:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439496080.2114.39.camel@sipsolutions.net>
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
 <1439456484.2114.6.camel@sipsolutions.net> <CADU+-uDS2C4w-dcbR8Rxx+jRfG7kNvu8JTncH-fxDnSp5NOBfQ@mail.gmail.com>
 <1439490787.2114.36.camel@sipsolutions.net> <CAJgzZoo3ifnocO84uMLa1=LKQjGWm_J3WTsw0xO2skPG9gDtng@mail.gmail.com>
 <1439496080.2114.39.camel@sipsolutions.net>
From: enh <enh@google.com>
Date: Thu, 13 Aug 2015 13:44:20 -0700
Message-ID: <CAJgzZoqQ=QP37k+7M_tW2HTeL_HB6YqiUsFC8eUHaGPFGPa6pA@mail.gmail.com> (sfid-20150813_224447_402879_19E50A1E)
Subject: Re: [PATCH 0/2] iw: fixes to Android.mk to include "iw" in AOSP builds
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Filipe Brandenburger <filbranden@google.com>,
	Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Christopher Wiley <wiley@google.com>,
	Ying Wang <wangying@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2015 at 1:01 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2015-08-13 at 12:48 -0700, enh wrote:
>>
>> i think you misunderstand what AOSP is. this code is currently in
>> AOSP master, and thus in internal master, and thus in a future
>> release.
>
> Great, but as I understand it, vendors are under no obligation to
> actually ship that code on their devices.
>
> If a vendor needs to have an iw that, for example, supports their own
> vendor commands (which, as I understand from the wifihal etc., Google
> is basically forcing vendors to have!), then the AOSP iw is useless and
> an own version needs to be built.

but given that our iw is your iw anyway... i don't understand the
situation in which they'd be inconvenienced here?

> johannes



-- 
Elliott Hughes - http://who/enh - http://jessies.org/~enh/
Android native code/tools questions? Mail me/drop by/add me as a reviewer.

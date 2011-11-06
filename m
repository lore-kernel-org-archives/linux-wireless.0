Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39879 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1KFRwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Nov 2011 12:52:06 -0500
Received: by gyc15 with SMTP id 15so3318060gyc.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Nov 2011 09:52:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320585006.11133.2.camel@jlt3.sipsolutions.net>
References: <CAFtRNNwXdeBfa-mFNyAVALgTxM-wrUthgMLS18VokqOSSiWPqg@mail.gmail.com>
	<1320585006.11133.2.camel@jlt3.sipsolutions.net>
Date: Sun, 6 Nov 2011 19:52:05 +0200
Message-ID: <CAFtRNNxGd7NSmjNhZboW5VOZ++j=D1E_G6E6RqXLA3Ssuu4XfQ@mail.gmail.com> (sfid-20111106_185538_250342_2B557FE5)
Subject: Re: 802.11p implementation...
From: Nick Kossifidis <mickflemm@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/6 Johannes Berg <johannes@sipsolutions.net>:
> On Sun, 2011-11-06 at 02:53 +0200, Nick Kossifidis wrote:
>> It seems a group of people have released an 802.11p implementation on
>> top of 2.6.31.
>>
>> http://www.gcdc.net/mainmenu/Home/downloads/Technology
>>
>> From a quick look changes on the kernel part are minimal, they moved
>> most of their work on userspace.
>> Also the ath5k related part is already upstream (half/quarter rate support).
>>
>> Could we get this upstream and merge it with current tools ? How does it look ?
>
> It looks like a website with tarballs, we can't put that into the
> kernel :-)
>
> johannes
>

That's because it's somehow complex, I thought you might be interested
to also look the whole thing + docs etc. The kernel-related parts are
inside GCDCCommStackV3-openwrt-gcdc.tgz
(GCDCCommStackV3-release/openwrt-gcdc/gcdc-backfire-10.03-V3/feed/patches/package/).

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick

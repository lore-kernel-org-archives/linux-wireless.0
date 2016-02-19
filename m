Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36359 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbcBSKGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 05:06:22 -0500
Received: by mail-wm0-f50.google.com with SMTP id g62so68254888wme.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2016 02:06:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455827082.2084.28.camel@sipsolutions.net>
References: <1455121877-7238-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1455121877-7238-2-git-send-email-lorenzo.bianconi83@gmail.com>
	<1455827082.2084.28.camel@sipsolutions.net>
Date: Fri, 19 Feb 2016 11:06:20 +0100
Message-ID: <CAA2SeNJyu8um=Og=3e6t8-f1TmGkFatx-kk6mrZ5LmY6yGN_Pg@mail.gmail.com> (sfid-20160219_110629_062999_8BD53E8D)
Subject: Re: [RFC 1/2] cfg80211: add radiotap VHT info to rtap_namespace_sizes
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Wed, 2016-02-10 at 17:31 +0100, Lorenzo Bianconi wrote:
>> Add IEEE80211_RADIOTAP_VHT entry to rtap_namespace_sizes array in
>> order to
>> define alignment and size of VHT info in tx radiotap
>>
> I think you forgot this patch in your [PATCH] resend, can you resend it
> properly?

Sorry, my fault :)  v2 on the way.
Best regards,
Lorenzo

>
> johannes



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep

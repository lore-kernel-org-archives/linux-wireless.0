Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:32465 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbYGPNb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 09:31:26 -0400
Received: by rn-out-0910.google.com with SMTP id k40so1761910rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2008 06:31:25 -0700 (PDT)
Message-ID: <1ba2fa240807160631n639a43b6jb4c2044233ecdeb7@mail.gmail.com> (sfid-20080716_153131_074403_7235C28F)
Date: Wed, 16 Jul 2008 16:31:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: add direct probe before association
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216214440.3422.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
	 <1216109902.23746.27.camel@johannes.berg>
	 <1ba2fa240807150131w4a08ae6dhae7bab8ab6adbde7@mail.gmail.com>
	 <1216111065.3535.3.camel@johannes.berg>
	 <1ba2fa240807160611h5d0d4ae5g68bfa2366cf514ec@mail.gmail.com>
	 <1216214440.3422.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 16, 2008 at 4:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Actually, it looks like I kept those for association because I decided
>> > that we weren't printing them too much. It might be much nicer to send
>> > them all as wireless events though, thoughts?
>>
>> Something like IWEVASSOCTIMEDOUT. Won't it make wpa_supplicant go nuts?
>
> No idea. Maybe just a private event with a string? Anyway, I guess we
> can keep it as-is because it doesn't add much and hopefully we won't
> print it over and over again, though I have seen a case where mac80211
> was stuck trying to associate again and again.

Okay if we are okay this one I will start pouring in the
disassociation patches from Ron
Tomas

> johannes
>

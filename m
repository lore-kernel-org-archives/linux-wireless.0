Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:36380 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXIHI0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 04:26:16 -0400
Received: by wa-out-1112.google.com with SMTP id v27so817741wah
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 01:26:15 -0700 (PDT)
Message-ID: <6b8cef970709080126t517cd2e3r292f6b933d615384@mail.gmail.com>
Date: Sat, 8 Sep 2007 04:26:15 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <1189237764.4506.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
	 <1189125944.28781.125.camel@johannes.berg>
	 <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
	 <1189193840.28781.197.camel@johannes.berg>
	 <6b8cef970709071438o6870cecej355119fee4396dcb@mail.gmail.com>
	 <1189202441.28781.208.camel@johannes.berg>
	 <6b8cef970709072129r5d7658b8v46e5b327638b8f06@mail.gmail.com>
	 <6b8cef970709072140o23cfd152nee56313db53739ae@mail.gmail.com>
	 <1189237764.4506.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/8/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Can you go to the end of the file net/wireless/core.c and exchange
> the module_init(cfg80211_init) with subsys_initcall(cfg80211_init)? It
> looks like that might be the problem.

Much like when I commented out the ieee80211_register_hw call, the
kernel booted fine, but there was no sign of the wireless card in the
logs or otherwise.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:43396 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbXIHP5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 11:57:09 -0400
Received: by wa-out-1112.google.com with SMTP id v27so924230wah
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 08:57:09 -0700 (PDT)
Message-ID: <6b8cef970709080857s69c055f2s1bc1ce6bd0ad4dfd@mail.gmail.com>
Date: Sat, 8 Sep 2007 11:57:08 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <1189244217.4506.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
	 <1189193840.28781.197.camel@johannes.berg>
	 <6b8cef970709071438o6870cecej355119fee4396dcb@mail.gmail.com>
	 <1189202441.28781.208.camel@johannes.berg>
	 <6b8cef970709072129r5d7658b8v46e5b327638b8f06@mail.gmail.com>
	 <6b8cef970709072140o23cfd152nee56313db53739ae@mail.gmail.com>
	 <1189237764.4506.14.camel@johannes.berg>
	 <6b8cef970709080126t517cd2e3r292f6b933d615384@mail.gmail.com>
	 <1189244217.4506.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/8/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> ?! That shouldn't have an effect like that. Are you positive that you
> put the register_hw call back?

Yeah, I thought the same thing, so I even did a git-reset --hard HEAD
and double-checked rt2x00dev.c to make sure everything was back to
normal before editing core.c again.

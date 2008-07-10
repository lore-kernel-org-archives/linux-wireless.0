Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:56977 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbYGJOr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 10:47:59 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1621181ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2008 07:47:58 -0700 (PDT)
Message-ID: <1ba2fa240807100747g285b5ff0of81bf619ad9ee3b9@mail.gmail.com> (sfid-20080710_164802_342132_0A624BFF)
Date: Thu, 10 Jul 2008 17:47:57 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] iwlwif: remove compilation warnings iwl_add_radiotap
Cc: "Bruno Randolf" <br1@einfach.org>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1215697922.3483.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215689322-25017-1-git-send-email-tomas.winkler@intel.com>
	 <200807101342.36920.br1@einfach.org>
	 <1ba2fa240807100525u3697e2f2rcde945a765412eb5@mail.gmail.com>
	 <1215697922.3483.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 4:52 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-07-10 at 15:25 +0300, Tomas Winkler wrote:
>
>> > what about using the generic function to add the radiotap header from
>> > mac80211? it should be flexible enough to handle all devices by now.
>
>> Why not go ahead.
>
> I always thought you were adding 11n stuff, but if that's not the case
> (and we may make mac80211 do that at some point) then that'd be a nice
> code removal.

I have never really looked into radio tap so I don't want to make any
statements here. If the 11n part can be done in mac80211 why not.
Tomas

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:30655 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566AbYFXLIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 07:08:40 -0400
Received: by rv-out-0506.google.com with SMTP id k40so7603342rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 04:08:37 -0700 (PDT)
Message-ID: <1ba2fa240806240408r8df7f06te548f55dc0e6eaad@mail.gmail.com> (sfid-20080624_130846_455704_D4579492)
Date: Tue, 24 Jun 2008 14:08:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
Cc: "Michael Buesch" <mb@bu3sch.de>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1214305396.8967.283.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-5-git-send-email-tomas.winkler@intel.com>
	 <200806241242.11727.mb@bu3sch.de>
	 <1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com>
	 <1214305396.8967.283.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2008 at 2:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> Still many people are using wireless extension and this is probably
>> most convenient way to get this info.
>> For example 4956 comes with 3 combinations g, ag, and agn.
>> It's displayed upon iwconfig
>
> Heh ok. I would just say "print out the rates" but I guess that doesn't
> work with HT yet.
>
>> >> +             strcat(name, "g");
>> >> +             is_ht |= sband->ht_info.ht_supported;
>> >
>> > What about b-only devices?
>>
>> See the log message...(known issue). Currently you have to loop over
>> rates to get this info. I wasn't sure if they are any b-only NICs
>> under mac80211 so I didn't run to implement it.
>
> There is, adm8211.

Okay I will send a patch on top of this one.
Thanks
Tomas

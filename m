Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:19922 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYIFWd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:33:59 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1029902fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 06 Sep 2008 15:33:58 -0700 (PDT)
Message-ID: <1ba2fa240809061533x4296448br11b326371d4fdb1f@mail.gmail.com> (sfid-20080907_003402_344853_C903F401)
Date: Sun, 7 Sep 2008 01:33:58 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 3/3] mac80211: remove disassociation code from ieee80211_set_associated
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220740231.21016.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-3-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-4-git-send-email-tomas.winkler@intel.com>
	 <1220740231.21016.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 7, 2008 at 1:30 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2008-09-07 at 01:14 +0300, Tomas Winkler wrote:
>
>> -     ieee80211_led_assoc(local, assoc);
>> +     ieee80211_led_assoc(local, 1);
>>
>> -     sdata->bss_conf.assoc = assoc;
>> +     sdata->bss_conf.assoc = 1;
>
> I think you should use "true" at least for the latter "1"
>
>> +     sdata->bss_conf.assoc = 0;
>
> and "false" here, and if the LED interface uses "bool" then for that
> too.
>
> The actual patch looks good to me though.

Will do
Thanks
Tomas

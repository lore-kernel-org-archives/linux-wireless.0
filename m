Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:18179 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZIARR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 13:17:59 -0400
Received: by fg-out-1718.google.com with SMTP id 22so847984fge.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 10:17:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090901163300.GA29047@jm.kir.nu>
References: <1251820465-11104-1-git-send-email-lrodriguez@atheros.com>
	<20090901163300.GA29047@jm.kir.nu>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 1 Sep 2009 19:17:39 +0200
Message-ID: <69e28c910909011017o49cc8dcehe84f08baba4a7a35@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] wireless: update mac80211 kconfig entry
To: Jouni Malinen <j@w1.fi>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 1, 2009 at 6:33 PM, Jouni Malinen<j@w1.fi> wrote:
> On Tue, Sep 01, 2009 at 08:54:25AM -0700, Luis R. Rodriguez wrote:
>> This updates the mac80211 kconfig entry to clarify
>> what it is and refer people to our wireless wiki for
>> more documentation.
>
>> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
>
>> -     tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
>> +     tristate "mac80211 - SoftMAC device support"
>
> Uh.. Do we really need to call this SoftMAC or well have that in the
> title? I prefer the current text or if you want to, just move the
> mac80211 into the beginning..
>
>
>> +       This option enables support for a framework used by IEEE-802.11
>
> s/IEEE-802.11/IEEE 802.11/
>
>> +       SoftMAC devices. SoftMAC devices allow for a finer control of the
>
> Again, I don't really like the term "SoftMAC" here..
>
>> +       hardware, allowing for 802.11 frame management to be done in software
>> +       for them, for both parsing and generation of 802.11 wireless frames.
>> +       Most 802.11 devices today tend to be of this type.
>
> s/802.11/IEEE 802.11/g
>
>> +       If you have new userspace utitlities which support nl80211 you do not
>
> s/utitlities/utilities/
>
>> +       need wireless-extensions to support a mac80211 device.
>
> s/wireless-extensions/wireless extensions/
>
>> +       When built as a module it will be called as mac80211, if not sure
>> +       you should build this as a module.
>
> s/, if/. If/

Also, s/called as/called/

>
> --
> Jouni Malinen                                            PGP id EFC895FA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

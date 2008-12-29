Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:60246 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbYL2Xkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 18:40:52 -0500
Received: by bwz14 with SMTP id 14so16774615bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 15:40:50 -0800 (PST)
Message-ID: <1ba2fa240812291540k3273f50che8adf89834672b3b@mail.gmail.com> (sfid-20081230_004059_554455_5628374A)
Date: Tue, 30 Dec 2008 01:40:50 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Delphi Real Estate" <Info@delphi-real-estate.com>
Subject: Re: Setting 'n' or 'a' Mode, and WPA2?
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200812291433.46427.Info@delphi-real-estate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200812270706.56478.Info@delphi-real-estate.com>
	 <200812291010.25373.Info@delphi-real-estate.com>
	 <1ba2fa240812291359r68325b34ycfaad8f51d922a4b@mail.gmail.com>
	 <200812291433.46427.Info@delphi-real-estate.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 30, 2008 at 12:33 AM, Delphi Real Estate
<Info@delphi-real-estate.com> wrote:
>
> On Monday 29 December 2008 13:59:19 Tomas Winkler wrote:
>> > How do you set only 5GHz 'n' mode?  WPA2?
>>
>> Just connect to 11n access point configured with WPA2 on 5GHz band.
>
> Of course, why didn't I think of that.  That's like saying, "To make pancakes, make pancakes."

You are not reading this correctly. The mode depends on access point
setting, there is nothing special to configure.

>
> My goal is to set /etc/network/interfaces to specifically configure the 4965AGN card for 5GHz 'n' mode *only* and WPA2.  I can't find any documentation on setting 'n' mode, nor WPA2 specifically.

For WPA2 you need wpa_supplicant so read it's manual for configuration.

> I'd like no broadcast of SSID, which I have working now on 'g' but don't know whether it's possible in 5GHz 'n'.  And I'd like cloaked traffic and as little handshake traffic as possible, although much of this seems impossible now with as little as is known about configuration.
>
> I'd just be happy with 5GHz 'n' mode and WPA2.  Isn't there any documentation?

Please note for 2.6.27 and above aggregation is broken in iwlagn
(4965) and this is what you need for good streaming. It shell be fixed
in near future hopefully.

Tomas

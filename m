Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:3238 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbYJQUCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 16:02:03 -0400
Received: by yw-out-2324.google.com with SMTP id 9so150347ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 13:02:01 -0700 (PDT)
Message-ID: <1ba2fa240810171302h7dcc92acr18c060425c4a93d@mail.gmail.com> (sfid-20081017_220221_342899_1266BCB0)
Date: Fri, 17 Oct 2008 22:02:01 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Richard Scherping" <richard@scherping.de>
Subject: Re: iwlagn: associating with AP causes kernel hiccup
Cc: "Frederik Himpe" <fhimpe@telenet.be>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48F8AEF1.5030603@scherping.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <gd5gs4$abi$1@ger.gmane.org> <1224104363.19219.30.camel@rc-desk>
	 <gd9v3f$3ft$1@ger.gmane.org> <gd9vpo$5ql$1@ger.gmane.org>
	 <48F8AEF1.5030603@scherping.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 17, 2008 at 5:27 PM, Richard Scherping <richard@scherping.de> wrote:
>>>>> When I associate with an AP, Linux 2.6.27 seems to "hang" for a few
>>>>> seconds. During that time, all sound stops playing and keyboard and
>>>>> mouse input is impossible.
>>>
>>> I'm using Mandriva 2009.0 x86_64 with wpa_supplicant and Mandriva's
>>> wireless network configuration tool (drakroam).
>>>
>>> Actually I just found out that running # ifconfig wlan0 down
>>> is enough to trigger the sound and mouse hanging for a few seconds.
>>
>> And shortly after I wrote that, while associating while getting an IP
>> with dhclient when associating with a WPA encrypted AP, I got this
>> backtrace in my logs:
>> [...]
>
> I have a similar problem here. No crash up to now, but the very same "hang" for a few seconds on "ifconfig wlan0 down". Interestingly this does only happen after a normal boot - once I did a suspend and resume (S3), there is no hang anymore.
>
> Hardware: Thinkpad T61p with Intel 4965 agn
> Software: Debian Lenny x86_64 with vanilla 2.6.27 kernel
>
Driver in 2.6.27 is not stable, please try to reproduce this in
current wireless-testing.git.
Thanks

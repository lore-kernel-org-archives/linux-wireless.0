Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:58945 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318AbZEKWZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 18:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <4A089E49.7080403@gmail.com>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	<4A089E49.7080403@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 May 2009 15:24:59 -0700
Message-ID: <43e72e890905111524t27c2659crad86643771d14a31@mail.gmail.com>
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Justin Mattock <justinmattock@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 2:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote=
:
> Adding some CCs.
>
> On 05/11/2009 07:02 PM, Justin Mattock wrote:
>> I've been trying to diagnose an issue
>> with 2.6.30-rc4. At first thinking it
>> was not the kernel, but the network manager
>> (in my case I use wicd).
>> with 2.6.29-rc8 the system starts up,
>> connects no problem.
>> but as soon as I load 2.6.30-rc4
>> I get limited connection to none.
>> in dmesg I see:
>>
>> [ =C2=A0 36.337419] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try =
1
>> [ =C2=A0 36.530106] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try =
2
>> [ =C2=A0 36.730100] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try =
3
>> [ =C2=A0 36.930101] wlan0: direct probe to AP 00:1e:2a:00:67:f0 time=
d out
>> [ =C2=A0 44.421728] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try =
1
>> [ =C2=A0 44.620080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try =
2
>> [ =C2=A0 44.820080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try =
3
>> [ =C2=A0 45.020076] wlan0: direct probe to AP 00:1e:2a:00:67:f0 time=
d out
>>
>> The type of encryption used is just
>> a standard WEP key(no WPA).
>>
>> has this been resolved already?

Can you provide more details, like the AP you used, and card you have?
(dmesg log would be nice).

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

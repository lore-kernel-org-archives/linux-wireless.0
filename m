Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58065 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3HTElF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 00:41:05 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so6092641pdi.5
        for <linux-wireless@vger.kernel.org>; Mon, 19 Aug 2013 21:41:04 -0700 (PDT)
Message-ID: <5212F35A.8050101@gna.org> (sfid-20130820_064108_906354_33724648)
Date: Tue, 20 Aug 2013 16:40:58 +1200
From: Christian Gagneraud <chgans@gna.org>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: chris <chgans@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: WiFi roaming question
References: <5211996B.4060800@gmail.com> <CABPxzYK_q9VXcXnGLb=8aFzD1ZJdLStyhBz-LRpvwg4oVaBTDw@mail.gmail.com>
In-Reply-To: <CABPxzYK_q9VXcXnGLb=8aFzD1ZJdLStyhBz-LRpvwg4oVaBTDw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/08/13 20:26, Krishna Chaitanya wrote:
>> It turned out that, as a client, I don't have to bother with roaming stuff, it simply works out of the box.
>
> Roaming has 2 types:
>
> 1) based on the disconnection (beacon loss)
> 2) based on the RSSI
>
> Is it really roaming doing background scanning and preauth #2 (or) a
> connect and disconnect (assuming same ssid and security) #1?
>
>> Though, I have a couple of questions regarding this OOBX (new buzz word seen here and there for "out of the box experience" :) ).
>> - At which level the roaming is done? Is it at the WiFi kernel stack (cfg/mac 80211), at driver level, or at chipset/firmware level or a mix of them?
>> - Can I change my setup, so that I have control over the roaming?
>> - Is it a good idea to try to manage that myself from userspace?
>
> wpa_supplicant (userspace) takes care of the roaming for you, i belive
> it has support for both types #1 and #2 (along with background scan)
>
> Some proprietary version which implement at driver/fw level, this
> reduces the roam delay as it need not involve any context switches.
>

Thanks Krishna for your answer.

Regards,
Chris

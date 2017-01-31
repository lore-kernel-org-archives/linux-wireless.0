Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:32916 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751889AbdAaMm6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 07:42:58 -0500
Received: by mail-ot0-f193.google.com with SMTP id f9so41725317otd.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2017 04:42:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <afccf3d4-b095-1a64-fd08-d559b44bcb72@neratec.com>
References: <HE1PR0701MB1803E46BC8EC38D682361523FC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <87lgtsjz6o.fsf@toke.dk> <CAA93jw5w6MaegbE+n9=-+F59vXTjEFGOH94Q=XYxiAqFKHeVfw@mail.gmail.com>
 <HE1PR0701MB1803A03DD96F300119936D0EFC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <87o9yo2v0s.fsf@toke.dk> <d23a5b33-9ec5-a3c3-81ed-91d8e9abe67a@neratec.com>
 <HE1PR0701MB18031C6DF4DF46865EBF9E87FC4A0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <f5adadba-2764-a7cc-c661-7061545341a7@neratec.com> <CAEvAWuGa6YSFA80mC0+saoGO5VWGNqfbyw94Nv0vfhSoQfD-Jw@mail.gmail.com>
 <HE1PR0701MB1803B7D5D0182EF7DD662B18FC4A0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <afccf3d4-b095-1a64-fd08-d559b44bcb72@neratec.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 31 Jan 2017 13:42:07 +0100
Message-ID: <CACna6rzaUWa9KbiN2A-WuhrBp3WEWbTWJ2NoaPAD5q+k3zk6Eg@mail.gmail.com> (sfid-20170131_134717_295499_1EBC00E9)
Subject: Re: Packet throughput (and those iperf data rate) with mac80211/ath9k
 is 20% worse than net80211/madwifi
To: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Cc: Klaus Kinski <jpo234@outlook.de>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Dave Taht <dave.taht@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 January 2017 at 10:52, Wojciech Dubowik
<wojciech.dubowik@neratec.com> wrote:
> On 31/01/17 10:46, Klaus Kinski wrote:
>>
>> BTW, if I read the sources correctly, than IBSS mode uses the TXQ
>> parameters from ieee80211_set_wmm_default with enable_qos = false which
>> means that qparam.txop = 0, e.g. bursting is disabled. Am I right?
>
> I guess so. But you need to look also at contention window sizes because it
> make a big impact on throughout with retries and collisions.

Klaus: I feel you keep dropping linux-wireless when sending your
replies. Please don't do that.

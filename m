Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:46563 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYG0PHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 11:07:06 -0400
Received: by an-out-0708.google.com with SMTP id d40so841858and.103
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 08:07:05 -0700 (PDT)
Message-ID: <43e72e890807270807k1a5967bfs1adf74f1a4d1e864@mail.gmail.com> (sfid-20080727_170710_930932_3CA27185)
Date: Sun, 27 Jul 2008 08:07:05 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: ath9k working, almost
Cc: "Alistair John Strachan" <alistair@devzero.co.uk>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217170761.2700.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200807261742.15693.alistair@devzero.co.uk>
	 <1217170761.2700.12.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 27, 2008 at 7:59 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Sat, 2008-07-26 at 17:42 +0100, Alistair John Strachan wrote:
>> Hi,
>>
>> The newly announced ath9k driver works great on an AR5418 Core 2 Duo Macbook,
>> WPA2-TKIP/AES et al all work fine. It would be good to see this driver in
>> wireless-testing, it completely replaces madwifi for me. I used linux.git
>> (2.6.26) + wireless-testing.git + my-wireless-testing.git with success.
>>
>> The only thing that I couldn't get working was the signal strength meter in
>> knetworkmanager. The AP signal strength shows up in iwlist ath0 scanning, but
>> whatever NM uses doesn't seem to work. All is good with madwifi, by
>> comparison.
>>
>> Any ideas? NM issue?
>
> The signal strength code in NM hasn't changed for quite a long time.
> Chances are it's the driver not reporting correctly.  What's the
> iwconfig output for while you're connected to your AP?
>
>  Link Quality=92/100  Signal level=-36 dBm  Noise level=-91 dBm
>
> That's the line I care about.

Its definitely borked, we just have to fix it. Its on our TODO list,
unless someone gets to it first.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:50741 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZGIRC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:02:56 -0400
Received: by qyk31 with SMTP id 31so255686qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 10:02:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0907090955v7b99a7ebq26e7cc67ab2493f5@mail.gmail.com>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
	<6c354a1a0906301550g70fbd9ddkecd09fc0e98dd1ef@mail.gmail.com>
	<b6c5339f0907020836n6162e8b8k3c1a7a24c335ac41@mail.gmail.com>
	<6c354a1a0907050513x3a3c91b3vb4b9de7196da1a14@mail.gmail.com>
	<6c354a1a0907061835g438d65daw38b08b9d55081f43@mail.gmail.com>
	<20090707030719.GC7199@hash.localnet> <6c354a1a0907072358u7408d865h5b32c587f63f39d@mail.gmail.com>
	<20090708114252.GG7199@hash.localnet> <6c354a1a0907090942o66c4e1b8ue2c952cf7ed7bf9a@mail.gmail.com>
	<b6c5339f0907090955v7b99a7ebq26e7cc67ab2493f5@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 9 Jul 2009 10:02:34 -0700
Message-ID: <43e72e890907091002r2dd36efevbfbce06155beb7e5@mail.gmail.com>
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
To: Bob Copeland <me@bobcopeland.com>
Cc: Jasin Colegrove <j.wholesalesupply@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 9, 2009 at 9:55 AM, Bob Copeland<me@bobcopeland.com> wrote:
> On Thu, Jul 9, 2009 at 12:42 PM, Jasin
> Colegrove<j.wholesalesupply@gmail.com> wrote:
>>> BTW, can you (re?)post the "Atheros AR5212 chip found (MAC xxx,
>>> PHY xxxx)?"
>>>
>> What exact information do you want and where can I find it?
>
> Run 'dmesg'; a string like the above is printed out when the module
> loads.  In case there was something broken specifically for your
> chipset, the mac/phy versions will help narrow it down.
>
>> $git bisect start v2.6.30-rc4 v2.6.29 -- drivers/net net/
>>
>> Is that what you where hinting at? I wasted a whole day trying to fix
>> errors in drivers/staging before I was told I could just disable
>> compilation of staging with one switch. Oh well...
>
> Yes, that's what I meant.  And it does help to have a relatively
> slimmed down .config, especially when bisecting. :\

I'd add net/mac80211 and net/wireless in there as well, just to be safe.

 Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:52580 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYGZTgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 15:36:23 -0400
Received: by an-out-0708.google.com with SMTP id d40so811317and.103
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2008 12:36:22 -0700 (PDT)
Message-ID: <43e72e890807261236j6ae4a28fuf8eaf423cce91edf@mail.gmail.com> (sfid-20080726_213643_668461_432AEA7D)
Date: Sat, 26 Jul 2008 12:36:22 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Subject: Re: ath9k working, almost
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200807262030.39724.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200807261742.15693.alistair@devzero.co.uk>
	 <43e72e890807261115r767bcd9bm909769525e10a836@mail.gmail.com>
	 <200807262030.39724.alistair@devzero.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 26, 2008 at 12:30 PM, Alistair John Strachan
<alistair@devzero.co.uk> wrote:
> On Saturday 26 July 2008 19:15:51 Luis R. Rodriguez wrote:
>> On Sat, Jul 26, 2008 at 9:42 AM, Alistair John Strachan
>>
>> <alistair@devzero.co.uk> wrote:
>> > Hi,
>> >
>> > The newly announced ath9k driver works great on an AR5418 Core 2 Duo
>> > Macbook, WPA2-TKIP/AES et al all work fine. It would be good to see this
>> > driver in wireless-testing, it completely replaces madwifi for me. I used
>> > linux.git (2.6.26) + wireless-testing.git + my-wireless-testing.git with
>> > success.
>>
>> Please keep in mind Linus' tree is just broken for wireless. But glad
>> it is working for you after your tremendous strange changes on your
>> tree...
>
> I explicitly said I was not using Linus' tree. Perhaps it is a
> misunderstanding on your part. If you use git pull inside a tree that another
> tree was originally forked from, it is much smaller and faster to check out.
> This is the process I was describing. I am pretty sure there are
> no "tremendous strange changes". :-)

Well my concern was I believe Linus' tree has the new MQ stuff and
wireless-testing doesn't. How did you handle that?

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:41394 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbZKIMLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:11:09 -0500
Received: by iwn10 with SMTP id 10so2286652iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:11:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091107134224.GA25893@tuxdriver.com>
References: <1257542956.6565.2.camel@localhost.localdomain>
	 <20091106214803.GL2782@tuxdriver.com>
	 <1257548493.3752.15.camel@localhost.localdomain>
	 <20091107134224.GA25893@tuxdriver.com>
Date: Mon, 9 Nov 2009 09:11:14 -0300
Message-ID: <cec7b3dc0911090411r18a3041cg7b4b0190bc7f68a3@mail.gmail.com>
Subject: Re: Changing from Minstrel to PID
From: =?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/7 John W. Linville <linville@tuxdriver.com>:
> On Fri, Nov 06, 2009 at 08:01:33PM -0300, Martín Ernesto Barreyro wrote:
>> El vie, 06-11-2009 a las 16:48 -0500, John W. Linville escribió:
>> > On Fri, Nov 06, 2009 at 06:29:16PM -0300, Martín Ernesto Barreyro wrote:
>> > > Hello, I have a rtl8187 wireless card and I've allways have problems
>> > > with the rate control using minstrel. So everytime my kernel updates
>> > > (recently it went from 2.30 to 2.31) i have to recompile mi kernel
>> > > setting pid as my default rate control algorithm.
>> > >
>> > > Is there a way to change that without compiling the kernel?
>> >
>> > No, but I wish there were...patches?  Anyone?
>> >
>> > John
>>
>> I've been searching and it seems that it could be added something like
>> modprobe mac80211 rc='pid'
>>
>> Would it be a good idea?
>
> Well if you are happy with a module option, we already have
> ieee80211_default_rc_algo.
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>

Yes I'm happy, I'll try it.
Is there any other way that it can be approached?

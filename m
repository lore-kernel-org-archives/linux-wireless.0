Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:62349 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZK3SwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 13:52:22 -0500
Received: by pzk1 with SMTP id 1so2883300pzk.33
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2009 10:52:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <60884ed00911301029t6d58f390j29dc29880320e9cf@mail.gmail.com>
References: <45f642440911300806s37297baan1140d6ec0eefefa7@mail.gmail.com>
	 <45e8e6c40911300910v264c9688j90a87db81f8a95a0@mail.gmail.com>
	 <60884ed00911301029t6d58f390j29dc29880320e9cf@mail.gmail.com>
Date: Mon, 30 Nov 2009 10:45:39 -0800
Message-ID: <45e8e6c40911301045n4956da4cx7da7051dca9e5acb@mail.gmail.com>
Subject: Re: Mesh freeze on node shutdown
From: Andrey Yurovsky <andrey@cozybit.com>
To: devel@lists.open80211s.org
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 30, 2009 at 10:29 AM, Cristian Nasuti
<nasuti.cristian@gmail.com> wrote:
> I think that I have the same problem.
>
> What I do is to configure 4 machine as mesh point and force paths (using the
> commands mpath mpath and new) for this topology:
>
> MP1 --- MP2 --- MP3 --- MP4
>
> Then I run iperf: suppose MP1 as client and MP2 as a server.
>
> All work fine, but if after a while I turn off one of the intermediate
> nodes, such as MP3 (with ifconfig MP3 down or just turning off the machine)
> after a couple of seconds client machine (MP1) freezing and needs rebooting.

Thanks Cristian.  This seems to be a recent regression and we'll look in to it.

  -Andrey

> _____________________________________________________________
>
> nasuti.cristian@gmail.com [Mail, GTalk, Live Messenger]
>
>
>
> 2009/11/30 Andrey Yurovsky <andrey@cozybit.com>
>>
>> Hi Francesco,
>>
>> On Mon, Nov 30, 2009 at 8:06 AM, Francesco
>> <francesco.cappuccio@gmail.com> wrote:
>> > All machines i have in my testbed freeze on any node shutdown, and there
>> > is
>> > no way out..need to hard reboot.
>>
>> Can you please post more details and instructions for how to reproduce
>> this?  Do we need to, for example, bring up a mesh, wait for plinks to
>> form, and then bring an interface down?  Do we need to have mpaths in
>> place and bring an interface down?  Thanks,
>>
>>  -Andrey
>>
>> > _______________________________________________
>> > Devel mailing list
>> > Devel@lists.open80211s.org
>> > http://open80211s.com/mailman/listinfo/devel
>> >
>> >
>> _______________________________________________
>> Devel mailing list
>> Devel@lists.open80211s.org
>> http://open80211s.com/mailman/listinfo/devel
>
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://open80211s.com/mailman/listinfo/devel
>
>

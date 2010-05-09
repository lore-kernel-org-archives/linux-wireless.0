Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:55074 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0EIPHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 11:07:50 -0400
Received: by pxi5 with SMTP id 5so1269911pxi.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 08:07:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100509004006.GA5790@tuxdriver.com>
References: <20100505120131.2b9f4e06@atom.pigiron.org>
	 <t2j446ae9281005061112z6eee4126z673947eb02dc4f12@mail.gmail.com>
	 <20100506215613.43477434@atom.pigiron.org>
	 <w2r445f43ac1005070929uacb5472dj231ff72ef0343860@mail.gmail.com>
	 <20100508093445.581e180e@atom.pigiron.org>
	 <20100509004006.GA5790@tuxdriver.com>
Date: Sun, 9 May 2010 08:07:49 -0700
Message-ID: <v2u445f43ac1005090807k1b4e653dy9b80a0c87067df0e@mail.gmail.com>
Subject: Re: The case of the bogus SSID
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: pigiron <pigiron@gmx.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

On Sat, May 8, 2010 at 5:40 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Sat, May 08, 2010 at 09:34:45AM -0500, pigiron wrote:
>> On Fri, 7 May 2010 09:29:18 -0700 Javier Cardona <javier@cozybit.com> wrote:
>
>> > I don't know about the router, nor if the IE ID clash is causing your
>> > problem, but moving the mesh codes somewhere else in the unassigned ID
>> > space would be a "A Good Thing To Do (tm)".
>
>> Really?
>>
>> Wouldn't that cause a problem for the kids running OLPC? For instance, where
>> some of the laptops are running an old level of code where WLAN_EID_MESH_ID=52
>> and others are running new code where WLAN_EID_MESH_ID=X.
>
> If I'm not mistaken, the mesh done in OLPC is already incompatible w/
> 802.11s anyway.

Yes, the currently deployed laptops implement an earlier version of
the 802.11s draft that's not compatible with what's in the kernel now.

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com

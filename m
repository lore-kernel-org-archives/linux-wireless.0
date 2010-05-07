Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:46644 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab0EGQ3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 12:29:18 -0400
Received: by pzk42 with SMTP id 42so578709pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 May 2010 09:29:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100506215613.43477434@atom.pigiron.org>
References: <20100505120131.2b9f4e06@atom.pigiron.org>
	 <t2j446ae9281005061112z6eee4126z673947eb02dc4f12@mail.gmail.com>
	 <20100506215613.43477434@atom.pigiron.org>
Date: Fri, 7 May 2010 09:29:18 -0700
Message-ID: <w2r445f43ac1005070929uacb5472dj231ff72ef0343860@mail.gmail.com>
Subject: Re: The case of the bogus SSID
From: Javier Cardona <javier@cozybit.com>
To: pigiron <pigiron@gmx.com>
Cc: Steve deRosier <steve@cozybit.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, May 6, 2010 at 7:56 PM, pigiron <pigiron@gmx.com> wrote:
> On Thu, 6 May 2010 11:12:15 -0700 Steve deRosier <steve@cozybit.com> wrote:
>
>> On Wed, May 5, 2010 at 10:01 AM, pigiron <pigiron@gmx.com> wrote:
>> > I noticed that decimal 52 is assigned to WLAN_EID_MESH_ID in the
>> > ieee80211.h file, and recently the same 52 was also assigned to
>> > WLAN_EID_NEIGHBOR_REPORT in the same enumerated ieee80211_eid{} structure.
>> >
>>
>> I can't answer the rest of your question, but AFAIK, the element IDs
>> for 802.11s mesh haven't been approved yet as the 802.11s draft
>> contains a note to that effect.  The current ANA database sheet I
>> could find (Feb 2010) does have 52 assigned to Neighbor Report, and
>> the mesh element IDs are nowhere to be found.
>>
> I agree. The 802.11k-2008 standard has already been approved with Element ID
> 52 = Neighbor Report, so it's probably almost a guarantee that 802.11s won't be
> assigning 52 to anything in the future.
>
> I'm kind of stuck on this problem. I could probably find out what's causing the
> failure and create a patch... but the patch wouldn't be "The Right Thing To
> Do(tm)" if the router isn't supposed to be spewing that data to begin with.

I don't know about the router, nor if the IE ID clash is causing your
problem, but moving the mesh codes somewhere else in the unassigned ID
space would be a "A Good Thing To Do (tm)".

Cheers,

Javier

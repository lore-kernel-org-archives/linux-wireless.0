Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53680 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950Ab0KQEmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 23:42:18 -0500
Received: by qyk12 with SMTP id 12so5913382qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 20:42:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289959503.29119.2.camel@jlt3.sipsolutions.net>
References: <1289867251-21559-1-git-send-email-javier@cozybit.com>
 <1289946246.3673.12.camel@jlt3.sipsolutions.net> <AANLkTimuW8wTVUW4dH1t+J6jhoEkFHZ7v5t78tXe050O@mail.gmail.com>
 <1289959503.29119.2.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 16 Nov 2010 20:41:57 -0800
Message-ID: <AANLkTimFe7uo28u3Sx4rc9uYJms7Ggh=yW9UMDDWgQce@mail.gmail.com>
Subject: Re: [PATCH] iw: Resolve namespace clash between station plink and
 vlan commands
To: Johannes Berg <johannes@sipsolutions.net>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 16, 2010 at 6:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-11-16 at 17:41 -0800, Javier Cardona wrote:
>
>> > I'll happily take this, but would you prefer to have the other one
>> > backed out instead?
>>
>> That would save us and some of our clients from having to change a
>> bunch of scripts, yes.
>
> Actually, I won't have time today, but it looks like they can be shared
> in some way? Maybe by sharing the same callback function or something? I
> mean -- it should be possible to do two things on set... not sure now,
> I'll take a look later. Maybe you can work with an older iw version
> until then?

We tried that at first but could not get the usage message right in
case of missing parameters.  If you can suggest a solution to this,
we'll be happy to implement it.

Cheers,

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com

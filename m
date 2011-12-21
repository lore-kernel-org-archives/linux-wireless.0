Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34060 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1LUIue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 03:50:34 -0500
Received: by iaeh11 with SMTP id h11so11578868iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 00:50:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d-iHJqu1d5BCETkebR6t7VnkwpuLSi6ddyZWhtVxaE8=Q@mail.gmail.com>
References: <1324288978-27162-1-git-send-email-helmut.schaa@googlemail.com>
	<1324310130.3414.3.camel@jlt3.sipsolutions.net>
	<CAGXE3d_dH1jeSVrmANd_OARqwY_NUkKu3He6Y7mP8atzas88pA@mail.gmail.com>
	<1324312896.3414.16.camel@jlt3.sipsolutions.net>
	<CAGXE3d9izM_cu=FpoYfLR1cx=tn+3BPMi9d7XEBfG-bkHR1oRA@mail.gmail.com>
	<CAGXE3d-iHJqu1d5BCETkebR6t7VnkwpuLSi6ddyZWhtVxaE8=Q@mail.gmail.com>
Date: Wed, 21 Dec 2011 09:50:33 +0100
Message-ID: <CAA93jw6=Q3Hs_-J7PJm4SYL35Lx35iwDhcZ6_uxXPOWmjxGpcQ@mail.gmail.com> (sfid-20111221_095037_732325_B498C6A8)
Subject: Re: [PATCH] mac80211: Fix frame classification in AP mode for relayed frames
From: Dave Taht <dave.taht@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 9:12 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> On Tue, Dec 20, 2011 at 9:37 AM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
>>>> So, you'd prefer to just copy over the TID as used by the source
>>>> STA (via the priority+256 hack maybe)?
>>>
>>> Seems simpler to me really, at least right now and as default. Not sure,
>>> maybe other people have more opinion? :)

Seeing this patch go by triggered me posting one of the patches I've
been using in cerowrt, which should appear on linux-wireless
as soon as the greylister gets done with me.

I think that much more extensive classification of wireless traffic is
highly desirable. In particular, tossing stuff with the TOS interactive bit
set into VI helps ssh traffic enormously.

It's the magic number hack that bugs me.


-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
FR Tel: 0638645374
http://www.bufferbloat.net

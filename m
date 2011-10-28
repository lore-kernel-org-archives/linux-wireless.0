Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52527 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1J1DsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 23:48:01 -0400
Received: by gyb13 with SMTP id 13so3287914gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 20:48:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319744223.32221.5.camel@jlt3.sipsolutions.net>
References: <1318929507-11447-1-git-send-email-helmut.schaa@googlemail.com>
	<1318929507-11447-2-git-send-email-helmut.schaa@googlemail.com>
	<CA+XVXfdKPdwXubpnX50zJRCXaxHpubAd3tDgWrCnQQggXKKhPQ@mail.gmail.com>
	<4758903.33HQxio52G@helmutmobil.site>
	<1319744223.32221.5.camel@jlt3.sipsolutions.net>
Date: Fri, 28 Oct 2011 05:48:00 +0200
Message-ID: <CAGXE3d_j1b+Vdyrf6bKH8Ugd-QGLtUnusEtsLSwMDTQhgAmOPQ@mail.gmail.com> (sfid-20111028_054804_407518_3AC40CCD)
Subject: Re: Re: [PATCH 2/2] iw: show STA flags in station dump
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <anamtsov@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 27, 2011 at 9:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-10-18 at 19:23 +0200, Helmut Schaa wrote:
>> Am Dienstag, 18. Oktober 2011, 18:41:11 schrieb Arik Nemtsov:
>> > On Tue, Oct 18, 2011 at 11:18, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
>> > >
>> > > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> > > ---
>> > >
>> > > Couldn't come up with a nice/short wording for "Managment frame
>> > > protection" and "Wireless Multimedia Extension" so I just used MFP
>> > > and WME/WMM instead.
>> > >
>> >
>> > Printing the NL80211_STA_FLAG_TDLS_PEER flag would be nice as well.
>>
>> Agreed, I somehow missed the (new) TDLS flag, also in the according
>> nl80211/mac80211 patches :(
>
> I'll apply this to iw fixed up but please send patches to the kernel.

Agreed, thanks.

And since we've got the flag mask iw will also work with a kernel that
doesn't provide the TDLS flags ;)

Helmut

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42144 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0KXTHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 14:07:01 -0500
Received: by qyk12 with SMTP id 12so118924qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 11:07:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101124185044.GA16361@tuxdriver.com>
References: <E1PKkCh-0005Ay-R2@sipsolutions.net> <4CED4464.2000106@archlinux.org>
 <20101124170639.GD7435@tuxdriver.com> <AANLkTin2n7ofZ0oom_aD+V4aFZ3dti1P77Mh6bpZOE6Z@mail.gmail.com>
 <20101124175035.GG7435@tuxdriver.com> <AANLkTi=BBw=T98eq2SXuvaLsQ=g8M9H4uLaCxOT0Ju44@mail.gmail.com>
 <20101124185044.GA16361@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 24 Nov 2010 11:06:40 -0800
Message-ID: <AANLkTi=T=Jn13y7x3n7dCQALNy+3-=_6Di5eEiTJpX7q@mail.gmail.com>
Subject: Re: [ANN] wireless-regdb: master-2010-11-22
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?Q?Thomas_B=C3=A4chler?= <thomas@archlinux.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 24, 2010 at 10:50 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Nov 24, 2010 at 10:04:50AM -0800, Luis R. Rodriguez wrote:
>> On Wed, Nov 24, 2010 at 9:50 AM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > On Wed, Nov 24, 2010 at 09:33:36AM -0800, Luis R. Rodriguez wrote:
>> >> On Wed, Nov 24, 2010 at 9:06 AM, John W. Linville
>> >> <linville@tuxdriver.com> wrote:
>> >> > On Wed, Nov 24, 2010 at 05:59:16PM +0100, Thomas Bächler wrote:
>> >> >> Am 23.11.2010 05:10, schrieb
>> >> >> wireless-cdvu00un1VgdHxzADdlk8Q@public.gmane.org:
>> >> >> > A new release of wireless-regdb (master-2010-11-22) is available at:
>> >> >> >
>> >> >> > http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2010.11.22.tar.bz2
>> >> >> >
>> >> >> > SHA1 sum: d0b008b4d32105cf6a87860b5a69e8066b03baaa
>> >> >> >
>> >> >> >
>> >> >> > For your convenience the individual regulatory.bin file can be downloaded from:
>> >> >> >
>> >> >> > http://wireless.kernel.org/download/wireless-regdb/regulatory.bins/2010.11.22-regulatory.bin
>> >> >> >
>> >> >> > SHA1 sum d7e558216ebe4d5ad01ccb0029c64456f740b9fd
>> >> >>
>> >> >> Hello,
>> >> >>
>> >> >> the binary does not work for me:
>> >> >>
>> >> >> $ sha1sum 2010.11.22-regulatory.bin
>> >> >> d7e558216ebe4d5ad01ccb0029c64456f740b9fd  2010.11.22-regulatory.bin
>> >> >> $ regdbdump ./2010.11.22-regulatory.bin
>> >> >> Database signature verification failed.
>> >> >>
>> >> >> The old 2009.11.25-regulatory.bin works fine.
>> >> >
>> >> > It seems to be working for me, even on a freshly installed RHEL6 box
>> >> > (so no random keys scattered about).
>> >> >
>> >> > Anyone else seeing this issue?  I seem to remember that we had a
>> >> > similar problem some time back...?
>> >>
>> >> I see the same issue:
>> >>
>> >> mcgrof@tux ~/devel/crda (git::master)$ ./regdbdump
>> >> /home/mcgrof/2010.11.22-regulatory.bin
>> >> Database signature verification failed.
>> >
>> > Alright, looks like I mislocated a key file when I switched laptops.
>> > I think it is corrected now...give it a try?
>>
>> What's the URL?
>>
>> mcgrof@tux ~/devel/crda (git::master)$ ./regdbdump 2010.11.22-regulatory.bin
>> Database signature verification failed.
>> mcgrof@tux ~/devel/crda (git::master)$ sha1sum 2010.11.22-regulatory.bin
>> d7e558216ebe4d5ad01ccb0029c64456f740b9fd  2010.11.22-regulatory.bin
>
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git;a=blob_plain;f=regulatory.bin;hb=a60a1d5b43e249502309c75707e3b220ce0fc48d

That works!

  Luis

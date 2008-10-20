Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50865 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYJTB2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 21:28:37 -0400
Received: by gxk9 with SMTP id 9so3128988gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 18:28:36 -0700 (PDT)
Message-ID: <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com> (sfid-20081020_032849_997692_63CBD98C)
Date: Sun, 19 Oct 2008 18:28:36 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Davide Pesavento" <davidepesa@gmail.com>
Subject: Re: crda packaging
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2008 at 8:57 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
> 2008/9/28 Luis R. Rodriguez <mcgrof@gmail.com>:
>> On Sat, Sep 27, 2008 at 9:59 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
>>> 2008/9/16 Johannes Berg <johannes@sipsolutions.net>:
>>>> Anyone want to pick it up for the various distros?
>>>
>>> I've written an ebuild for Gentoo and attached it to bug #238879.
>>> https://bugs.gentoo.org/show_bug.cgi?id=238879
>>
>> Would you be able to start packaging crda as well? It'll be very good
>> to have this by 2.6.28 and if you guys have a compat-wireless, it will
>> soon require it (by 2.6.29).
>>
>
> I'll be glad to help ;)

Excellent, thanks :)

>> The regulatory.bin and the rsa public key will soon be posted on some
>> place on John Linville's web space somewhere, so that'll change soon I
>> hope.
>>
>
> Do you think the regulatory database should be split from the package
> that contains the crda daemon? If so, regulatory.bin should be
> versioned as well...

Yes, absolutely, the idea is to split db.txt into a separate git tree
too actually so that should help with keeping track of changes
separately and thinking of them separately.

We just need to get this git tree created. What crda will need though
is to wget the RSA public key so it can be built with support for new
arbitrary updates to the binary db. Give us a few days, we'll get this
setup.

  Luis

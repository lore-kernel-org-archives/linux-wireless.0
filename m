Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:41947 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYKWSk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 13:40:59 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1409853fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2008 10:40:58 -0800 (PST)
Message-ID: <2da21fe50811231040i45c3cda5l16379093b4e85265@mail.gmail.com> (sfid-20081123_194105_172013_C69FF2BD)
Date: Sun, 23 Nov 2008 19:40:58 +0100
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: crda packaging
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890811171421j3f41234dnf451e25d5e58abdc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com>
	 <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com>
	 <2da21fe50811161258v58efe236r492d59c8b9228b81@mail.gmail.com>
	 <20081117202749.GB5994@tesla>
	 <43e72e890811171421j3f41234dnf451e25d5e58abdc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2008 at 23:21, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Nov 17, 2008 at 12:27 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Sun, Nov 16, 2008 at 12:58:43PM -0800, Davide Pesavento wrote:
>>> On Mon, Oct 20, 2008 at 02:28, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> > On Sun, Oct 19, 2008 at 8:57 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
>>> >>
>>> >> Do you think the regulatory database should be split from the package
>>> >> that contains the crda daemon? If so, regulatory.bin should be
>>> >> versioned as well...
>>> >
>>> > Yes, absolutely, the idea is to split db.txt into a separate git tree
>>> > too actually so that should help with keeping track of changes
>>> > separately and thinking of them separately.
>>> >
>>> > We just need to get this git tree created. What crda will need though
>>> > is to wget the RSA public key so it can be built with support for new
>>> > arbitrary updates to the binary db. Give us a few days, we'll get this
>>> > setup.
>>> >
>>> >  Luis
>>> >
>>>
>>> Any updates on this?
>>
>> I think we'll have this done by the end of the day.
>
> OK this is now done. We have a new git tree which John maintains for
> the database:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
>
> All you need from that is the regulatory.bin, you don't need to run
> make or anything, just cp the regulatory.bin to the preferred
> location. Right now this is built into CRDA and its
> /usr/lib/crda/regulatory.bin.
>
> Then do a git pull on crda and try to build and let us know if you run
> into any issues for packaging. The documentation on the
> wireless.kernel.org wiki needs some good updating.
>
>  Luis
>

Great! Thanks a lot!
Are there any tarballs around? I couldn't find them on
http://wireless.kernel.org/download/...

Regards,
Davide

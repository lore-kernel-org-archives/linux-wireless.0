Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:59659 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYKQWZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 17:25:43 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1125649yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 14:25:41 -0800 (PST)
Message-ID: <43e72e890811171425i3b1fc1bdk39a2c36333315e11@mail.gmail.com> (sfid-20081117_232548_913405_B6BC1E4E)
Date: Mon, 17 Nov 2008 14:25:41 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Davide Pesavento" <davidepesa@gmail.com>
Subject: Re: crda packaging
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
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

On Mon, Nov 17, 2008 at 2:21 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
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

Oh and this has a tag for date on the release so we'd get a new
wireless-regdb package for each new tag.

  Luis

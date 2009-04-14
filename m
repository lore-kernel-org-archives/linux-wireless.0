Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:11008 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZDNAMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 20:12:18 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2382350wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 17:12:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090414000835.GA31504@storm.local.network>
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com>
	<20090320131014.GG25237@storm.local.network> <20090414000835.GA31504@storm.local.network>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Apr 2009 17:12:02 -0700
Message-ID: <43e72e890904131712y55ba7f16sa8cb568128afeaeb@mail.gmail.com> (sfid-20090414_021222_034767_D52E08B7)
Subject: Re: VT6656 driver source now GPL
To: Forest Bond <forest@alittletooquiet.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 5:08 PM, Forest Bond <forest@alittletooquiet.ne=
t> wrote:
> Hi,
>
> On Fri, Mar 20, 2009 at 09:10:15AM -0400, Forest Bond wrote:
>> On Thu, Mar 19, 2009 at 09:45:19AM -0700, Luis R. Rodriguez wrote:
>> > On Thu, Mar 19, 2009 at 9:42 AM, Forest Bond <forest@alittletooqui=
et.net> wrote:
>> > > Hi,
>> > >
>> > > VIA has released a new version of the VT6656 driver source, and =
it now has a
>> > > proper license!
>> > >
>> > > =C2=A0http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x=
86.zip
>> > >
>> > > As you may recall, the previous version lacked a license altoget=
her, making it
>> > > unfit for distribution.
>> > >
>> > > I'd really like to see this driver integrated into the kernel. =C2=
=A0Does anyone care
>> > > to comment regarding feasibility?
>> >
>> > Indeed good news, what is the latest kernel it compiles for? If it
>> > compiles on Linus' tree it can be stashed into staging while it ge=
ts
>> > properly ported.
>>
>> Just so I know who to pester*, will you be driving this? =C2=A0Do yo=
u have interest
>> in also pulling in the VT6655 driver?
>>
>> * I won't pester that much. ;)
>
> I'm getting the sense that there is not a lot of developer interest i=
n these
> drivers. =C2=A0Is there anything I can do to aid in getting these dri=
vers into the
> kernel?
>
> I would be willing to send patches, however, my experience with kerne=
l hacking
> is limited and I don't have a lot of time available to contribute. =C2=
=A0With a
> little direction, though, I might be able to get somewhere.
>
> Any input would be appreciated.
>

Best thing is to stash them into staging and hope someone will be
interested in porting it.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

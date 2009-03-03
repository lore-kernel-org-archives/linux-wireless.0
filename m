Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:53663 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZCCSne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 13:43:34 -0500
MIME-Version: 1.0
In-Reply-To: <49AD7361.308@s5r6.in-berlin.de>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>
	 <49ACC6B0.409@garzik.org>
	 <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>
	 <20090303072637.GB4440@kroah.com>
	 <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
	 <49AD4C74.1060704@s5r6.in-berlin.de>
	 <43e72e890903030923v27c47f5anc184c0e8085bc5c1@mail.gmail.com>
	 <49AD7361.308@s5r6.in-berlin.de>
Date: Tue, 3 Mar 2009 10:43:32 -0800
Message-ID: <43e72e890903031043m1fe417eay4420e734064a5882@mail.gmail.com> (sfid-20090303_194343_094878_0D2E4927)
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus' tree"
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
	wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 3, 2009 at 10:13 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Luis R. Rodriguez wrote:
>> On Tue, Mar 3, 2009 at 7:27 AM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>>> Luis R. Rodriguez wrote:
>>>> OK small silly example is convincing distributions it may be a goo=
d
>>>> idea to carry linux-next kernel packages as options to users to
>>>> hopefully down the road reduce the delta between what they carry a=
nd
>>>> what is actually upstream.
>>> Distros would do their users a bigger favour if [...]
>>
>> I don't think I was very clear in what I meant about "carrying
>> linux-next kernel packages as an option". What I meant was carrying =
it
>> just as an option for those users who want to test bleeding edge
>> without compiling their own linux-next, _not_ to merge linux-next
>> things into their own default kernel release and shove it down users
>> throats.
>
> Sorry, I meant "bigger favour" relative to carrying an own delta of
> considerable size.
>
> Packaging linux-next would be fine if the workload isn't a problem fo=
r
> the packager. =C2=A0As pointed out elsewhere, there are caveats with
> linux-next (e.g. a functionality which was in it yesterday could be g=
one
> today because of a merge issue), but that's the nature of bleeding ed=
ge
> of course.

Sure, understood. That's all I meant really.

My argument here I guess is that the reasons used to support the
"equivalent fix" policy for patches upstream makes it apparent why
linux-next is so important and my hope would be to get it more
exposure by having distributions let users test it (as an option to go
with bleeding edge) and this in turn help stabilize code in our next
release.

But I certainly don't expect every distribution to carry such a
package, nor would I expect them to want to deal with it. Just wanted
to build a good case for distributions to consider it.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38183 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZCCHUK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 02:20:10 -0500
Message-ID: <49ACDA25.3020104@garzik.org> (sfid-20090303_082016_237749_3332E3D2)
Date: Tue, 03 Mar 2009 02:20:05 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus' tree"
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>	 <49ACC6B0.409@garzik.org> <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>
In-Reply-To: <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Mon, Mar 2, 2009 at 9:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> Luis R. Rodriguez wrote:
>>> While extending the documentation for submitting Linux wireless bug
>>> reports [1] we note the stable series policy on patches -- that of
>>> having an equivalent fix already in Linus' tree. I find this
>>> documented in Documentation/stable_kernel_rules.txt but I'm curious if
>>> there is any other resource which documents this or elaborates on this
>>> a bit more. I often tell people about this rule or push _really_ hard
>>> on testing "upstream" but some people tend to not understand. I think
>>> that elaborating a little on this can help and will hopefully create
>>> more awareness around the importance of trees like Stephen's
>>> linux-next tree.
>> Just have people google for GregKH's copious messages, telling people a fix
>> needs to be upstream before it goes into -stable.
>>
>> Typically you make things easy by emailing stable@kernel.org with a commit
>> id.
>>
>> There are only two exceptions:
>> * fix is upstream, but needs to be modified for -stable
>> * fix is not needed at all in upstream, but -stable still needs it
> 
> This certainly helps, I'm also looking for good arguments to support
> the reasoning behind the policy so that not only will people follow
> this to help development but _understand_ it and so that they can
> themselves promote things like linux-next and realize why its so
> important. Mind you -- upstream for us in wireless for example is not
> Linus its John's tree so what we promote is not to get the fix first
> into Linus' tree but first into John's tree. Which is obvious to
> developers but perhaps not to others.
> 
> Let me try:
> 
> Our "equivalent fix" policy exists to ensure the next kernel release
> doesn't suck more, only less. We do this by ensuring every single
> patch that goes into any stable kernel is already applied on the tree
> used to release the next kernel release. As an consequence of this
> policy we also tend to create more exposure and create better focus to
> the different development trees that lead to Linus's tree thereby
> making the distributed development model we depend on more apparent
> and better structured.

Or more simply "so that fixes don't get lost" :)  -stable is effectively 
a dead-end side branch, not the main trunk.

	Jeff




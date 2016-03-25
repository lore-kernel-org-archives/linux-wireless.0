Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60724 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115AbcCYRXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 13:23:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 7BF3E2074F
	for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2016 13:23:39 -0400 (EDT)
Date: Fri, 25 Mar 2016 13:23:28 -0400
From: Greg KH <greg@kroah.com>
To: Evgeny Novikov <novikov@ispras.ru>
Cc: Till Kamppeter <till.kamppeter@gmail.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"lsb-discuss@lists.linux-foundation.org"
	<lsb-discuss@lists.linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Open Printing <printing-architecture@lists.linux-foundation.org>
Subject: Re: [lsb-discuss] Google Summer of Code 2016 - Many new applications
Message-ID: <20160325172328.GC26115@kroah.com> (sfid-20160325_182353_650885_09F68EB8)
References: <56F4266B.4060605@gmail.com>
 <1943931458892174@web3o.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1943931458892174@web3o.yandex.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 25, 2016 at 10:49:34AM +0300, Evgeny Novikov wrote:
> Hi,
> 
> I see briefly all proposals and suggest the following.
> 
> Ignore definitely trash proposals for which we even can't expect anything good:
> ABHISHEK KUMAR SINGH - AUTOMATIC GUN FIRING USING ULTRASONIC RADAR - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6488763748319232/
> Rihab - GirlySpace - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6439770653720576/
> Abraham Masri - Kedos Operating System - Proposal Draft - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/5824313382928384/ (Greg marked this proposal as not valid)
> Wenhui Zhang - LLVM - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/5513414914867200/ (Jan-Simon marked it as spam)
> devesh8091 - Penguin - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/4940939340546048/
> Ricky Muhammad - The Linux Foundation - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/5458068905132032/ (Greg pointed what to do but the student ignored this)
> 
> This student suggested two proposals that aren't good and likely the student isn't going to improve them. So I suggest to ignore them if Greg doesn't mind:
> Sandhya - IIO driver - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/5372313474170880/
> Sandhya - memory management latency tracing - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/5404748865863680/
> 
> This student creates 3 different applications for 3 different projects without providing any particular details. I see his applications a bit and this doesn't look like he really wants and can to implement something valuable. So I suggest to just ignore his proposals:
> Ravike14 - GSOC 2016- The Linux Foundation (Driver Backport) - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/5414085923438592/
> Ravike14 - GSOC 2016- The Linux Foundation (Driver Backport) - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6630431633965056/
> Ravike14 - GSOC 2016- The Linux Foundation (General kernel work) - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6384381044195328/
> 
> Select one of the proposals for the same project if it isn't really required to have two or more students working concurrently/collaboratively:
> Erick 2206 - Diagnose My Ceph Cluster - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/5040149662531584/ and penguinRaider - Diagnose my ceph cluster - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6137977797345280/ (at the moment both are accepted)
> narendasan - Proposal for work on QEMU API for Rust - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/5184290644033536/ and DrewSidman - QEMU API for Rust - https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6135625933651968/ (at the moment both are accepted although the second application even doesn't have any proposal just the abstract)
> 
> 
> The rest proposals (~9) are either already thoroughly reviewed and accepted or need this ASAP.

One new proposal just got submitted:
	https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6320691074826240/

and I'm willing to mentor it, as long as the "final" application matches
up with the draft one.  I didn't see anywhere to "star" an application,
why do some have that mark and others do not?

thanks,

greg k-h

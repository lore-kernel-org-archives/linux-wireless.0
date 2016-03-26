Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58156 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351AbcCZREN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2016 13:04:13 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 6C5B72042C
	for <linux-wireless@vger.kernel.org>; Sat, 26 Mar 2016 13:04:12 -0400 (EDT)
Date: Sat, 26 Mar 2016 10:04:09 -0700
From: Greg KH <greg@kroah.com>
To: Till Kamppeter <till.kamppeter@gmail.com>
Cc: Evgeny Novikov <novikov@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"lsb-discuss@lists.linux-foundation.org"
	<lsb-discuss@lists.linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Open Printing <printing-architecture@lists.linux-foundation.org>,
	chris holcombe <chris.holcombe@canonical.com>,
	Chris MacNaughton <chris.macnaughton@canonical.com>
Subject: Re: [lsb-discuss] Google Summer of Code 2016 - Many new applications
Message-ID: <20160326170409.GA27584@kroah.com> (sfid-20160326_180420_148096_4C0DF917)
References: <56F4266B.4060605@gmail.com>
 <1943931458892174@web3o.yandex.ru>
 <56F5D04A.20506@gmail.com>
 <56F5D11B.7000803@gmail.com>
 <20160326001803.GB15767@kroah.com>
 <56F5DA55.6030802@gmail.com>
 <20160326141540.GA4104@kroah.com>
 <56F69BDC.7050900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56F69BDC.7050900@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 26, 2016 at 11:25:32AM -0300, Till Kamppeter wrote:
> Can you give me a list of all the other proposals which you considered not
> worthwhile (and where we do not need to wait for another mentor's opinion)
> so that I can mark them ignored?

Please mark these as "ignored" because they are really not even valid
applications:

	https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6700817021140992/
	https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6384381044195328/
	https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/5181271886004224/
	https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/6626850369437696/
	https://summerofcode.withgoogle.com/dashboard/organization/6564234674569216/proposal/4823798872276992/


That should complete all applications in the "kernel" category.  There
are a bunch of CELF and "QEMU with Rust" applications that I know
nothing about, and there doesn't seem to be a category for.  I'm
assuming someone else is going to review / mentor those.

If there's anything else I need to do here, becides try to find a
co-mentor, please let me know.

thanks,

greg k-h

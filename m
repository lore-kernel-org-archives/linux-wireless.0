Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:48837 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYIIFsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 01:48:09 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing rebased again?
References: <1220858698.28282.324.camel@debian.sh.intel.com>
	<20080908142117.GA24557@tuxdriver.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 09 Sep 2008 08:47:34 +0300
In-Reply-To: <20080908142117.GA24557@tuxdriver.com> (ext John W. Linville's message of "Mon\, 8 Sep 2008 10\:21\:17 -0400")
Message-ID: <873ak9hnux.fsf@nokia.com> (sfid-20080909_074813_389516_164FF828)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville <linville@tuxdriver.com> writes:

> On Mon, Sep 08, 2008 at 03:24:58PM +0800, Zhu Yi wrote:
>
>> I find the wireless-testing GIT has been rebased twice in less than one
>> month. Does it mean you give up making it a long lived merge-able tree?
>> This may affect to the downstream wireless drivers code management. At
>> least for iwlwifi, we'd expect to merge with wireless-testing everytime.
>
> There must be some mistake, it has not been rebased at all -- at
> least not as far as git is concerned.  I have done my now customary
> "revert everything, pull from Linus re-apply" thing that I call a
> virtual rebase, but the history has remained continuous.
>
> The non-master branches do get rebased of course.  Perhaps you saw
> that and thought that master had been rebased as well?

FWIW, I also have had conflicts while pulling wireless-testing#master
and I similarly thought that you have rebased it. But if you didn't I
don't know what happened.

-- 
Kalle Valo

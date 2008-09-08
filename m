Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50446 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYIHOaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 10:30:30 -0400
Date: Mon, 8 Sep 2008 10:21:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless-testing rebased again?
Message-ID: <20080908142117.GA24557@tuxdriver.com> (sfid-20080908_163044_248743_28CC3FB8)
References: <1220858698.28282.324.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1220858698.28282.324.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2008 at 03:24:58PM +0800, Zhu Yi wrote:

> I find the wireless-testing GIT has been rebased twice in less than one
> month. Does it mean you give up making it a long lived merge-able tree?
> This may affect to the downstream wireless drivers code management. At
> least for iwlwifi, we'd expect to merge with wireless-testing everytime.

There must be some mistake, it has not been rebased at all -- at
least not as far as git is concerned.  I have done my now customary
"revert everything, pull from Linus re-apply" thing that I call a
virtual rebase, but the history has remained continuous.

The non-master branches do get rebased of course.  Perhaps you saw
that and thought that master had been rebased as well?

John
-- 
John W. Linville
linville@tuxdriver.com

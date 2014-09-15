Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44316 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaIOTPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 15:15:08 -0400
Date: Mon, 15 Sep 2014 15:02:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: g@tuxdriver.com, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] hostap: proc: substitute loops by %*phN
Message-ID: <20140915190213.GE3891@tuxdriver.com> (sfid-20140915_211519_709074_616B543D)
References: <1409927416-27101-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20140911192721.GD22872@tuxdriver.com>
 <1410506650.7023.29.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1410506650.7023.29.camel@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2014 at 10:24:10AM +0300, Andy Shevchenko wrote:
> On Thu, 2014-09-11 at 15:27 -0400, John W. Linville wrote:
> > Applying: hostap: proc: substitute loops by %*phN
> > error: patch failed: drivers/net/wireless/hostap/hostap_proc.c:184
> > error: drivers/net/wireless/hostap/hostap_proc.c: patch does not apply
> 
> Hmm... Originally it was applied on top of linux-next (few days ago).
> 
> Just checking with current origin/master. Applied correctly.
> 
> Moreover, took recent wireless-next. No issues.
> Which tree you are trying?

It only to wireless-next with some fuzz.  I think I have it sorted now.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

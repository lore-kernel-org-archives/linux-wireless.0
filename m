Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47984 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYICPAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 11:00:30 -0400
Date: Wed, 3 Sep 2008 10:50:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: at76_usb.[ch] gone fishing from wireless-testing ?
Message-ID: <20080903145007.GL3050@tuxdriver.com> (sfid-20080903_170039_895884_A8FDCCAE)
References: <43e72e890809021953o29c6ba53wcdf7630d4ff10b30@mail.gmail.com> <87vdxedje8.fsf@nokia.com> <43e72e890809022003gfd462d2ma8d68f032754c121@mail.gmail.com> <20080903125352.GI3050@tuxdriver.com> <87zlmpuwmc.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87zlmpuwmc.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 03, 2008 at 05:34:03PM +0300, Kalle Valo wrote:
> John W. Linville <linville@tuxdriver.com> writes:
> 
> > Anyone want to talk me out of pulling-in the at76 parts?
> 
> Sorry, I don't quite understand what pulling-in means here.

I just mean making sure it is (and continues to be) in
wireless-testing's master branch.

> But personally I don't mind, choose which one is best in your opinion.
> If you drop it, I can always resubmit it when it's properly working.

Leaving it in has encouraged people to keep it up-to-date (or at least
compiling) across mac80211 driver API changes.  Whether or not this
has been worthwhile is, of course, debatable.

John

P.S.  For the record, I _would_ like to see a working at76 driver
make it upstream at some point.
-- 
John W. Linville
linville@tuxdriver.com

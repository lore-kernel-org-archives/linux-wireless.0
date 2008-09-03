Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58969 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYICNpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 09:45:33 -0400
Date: Wed, 3 Sep 2008 09:38:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <j@w1.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: at76_usb.[ch] gone fishing from wireless-testing ?
Message-ID: <20080903133802.GK3050@tuxdriver.com> (sfid-20080903_154537_512040_C98615AE)
References: <43e72e890809021953o29c6ba53wcdf7630d4ff10b30@mail.gmail.com> <87vdxedje8.fsf@nokia.com> <43e72e890809022003gfd462d2ma8d68f032754c121@mail.gmail.com> <20080903125352.GI3050@tuxdriver.com> <20080903130439.GJ3050@tuxdriver.com> <20080903132448.GT17345@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080903132448.GT17345@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 03, 2008 at 04:24:48PM +0300, Jouni Malinen wrote:
> On Wed, Sep 03, 2008 at 09:04:40AM -0400, John W. Linville wrote:
> > On Wed, Sep 03, 2008 at 08:53:52AM -0400, John W. Linville wrote:
> > > Crap, I botched my lastest update.  I'll pull in the part that adds
> > > -wl to the version for sure.  Anyone want to talk me out of pulling-in
> > > the at76 parts?
> > 
> > Hmmm...upon further review, both my local copy and the one at
> > kernel.org seem to have the proper bits AFAICT...?
> 
> I don't see -wl in EXTRAVERSION in kernel.org version (1) or my own
> clone. Both are at commit 908dd0b965e64fcc2eb64152bac65f2876c34e0b. I
> noticed this disappearing at one of the updates since I had to add a
> local patch to be able to update my modules without rebooting..
> 
> (1)
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob_plain;f=Makefile;hb=908dd0b965e64fcc2eb64152bac65f2876c34e0b

The -wl comes from localversion-wireless in the kernel's root
directory.  Has something changed recently to break that mechanism?

John
-- 
John W. Linville
linville@tuxdriver.com

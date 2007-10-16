Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:59586 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbXJPRbU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 13:31:20 -0400
Date: Tue, 16 Oct 2007 10:29:59 -0700
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlist and network-manager bug report
Message-ID: <20071016172959.GA20653@bougret.hpl.hp.com> (sfid-20071016_183124_096440_F5F1C293)
Reply-To: jt@hpl.hp.com
References: <1189526874.6161.30.camel@johannes.berg> <20071016005711.GA10957@bougret.hpl.hp.com> <20071016165803.GA5677@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071016165803.GA5677@tuxdriver.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 16, 2007 at 12:58:03PM -0400, John W. Linville wrote:
> 
> Jean, you can keep whining and complaining.  But you never address
> the issue of preserving the userland ABI.  Simply releasing a new,
> smarter, better wireless-tools does not change the situation.

	The old ABI has been deprecated for almost 2 years. Compare to
some other kernel ABI that change almost on a weekly basis, that's
quite stable. You will not find anything in the wild using the old
ABI.

> I don't see how the patch you wish to revert has anything to do with
> the umlaut issue.

	Try Wireless Tools 30. That's the first version that support
the umlaut.

>  If it does, please explain how or feel free to propose a patch that
> corrects it while still preserving the userland ABI.

	It can not be done. The point is that the current hack in the
kernel is based on faulty assumptions, and therefore does not work as
advertised.

> John
> 
> P.S.  Please note that the userland ABI concern is not some pet issue
> for me.  This comes from the community at large, including Linus,
> Jeff Garzik, and other notable contributors.

	Unfortunately, it's only true with some subsystems, but not
all of them. If you go back to the original thread, the concern was
the minimise user disruption. The point Linus made is that ABI change
are not forbidden, we just need to make sure to minimise user
disruption.

	Have fun...

	Jean

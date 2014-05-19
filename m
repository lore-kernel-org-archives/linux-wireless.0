Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55575 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaESUaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 16:30:12 -0400
Date: Mon, 19 May 2014 16:29:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: How to disable beacon filtering in iwlwifi in 3.13 and 3.14
Message-ID: <20140519202913.GJ7650@tuxdriver.com> (sfid-20140519_223022_936585_C6D9A721)
References: <CANUX_P2MSK_rUMyN2xa8A9dZwuPSKh+eiOr10KG6PocCQdVhvA@mail.gmail.com>
 <20140519194156.GA5991@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140519194156.GA5991@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 12:41:56PM -0700, Greg KH wrote:
> On Mon, May 19, 2014 at 01:40:34PM +0300, Emmanuel Grumbach wrote:
> > Hi,
> > 
> > I need to disable a feature on 3.13 and 3.14. But I don't have any
> > patch upstream that I can point to as the patch that needs to be
> > backported.
> > We have a feature that is buggy in 3.13 and 3.14. We refactored (and
> > fixed) this feature in 3.15 but the refactor is really not stable
> > material, so basically, I can't backport the fix to 3.13 / 3.14. A
> > user reported that disabling the feature solved (part of) his issues:
> > https://bugzilla.kernel.org/show_bug.cgi?id=72601.
> > OTOH, I don't have any patch in linux.git that could be backported to
> > do what I want in 3.13 / 3.14 - i.e. disable the feature.
> > What is the right process here? I understand that this isn't covered
> > by the "stable rules". So what should I do here?
> 
> Get the maintainer's approval to apply this patch and I can queue it up.

Seems ok to me.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

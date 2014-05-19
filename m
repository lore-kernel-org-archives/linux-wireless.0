Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaESVQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 17:16:04 -0400
Date: Mon, 19 May 2014 14:15:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: How to disable beacon filtering in iwlwifi in 3.13 and 3.14
Message-ID: <20140519211553.GA32321@kroah.com> (sfid-20140519_231608_697733_A1E5F7DE)
References: <CANUX_P2MSK_rUMyN2xa8A9dZwuPSKh+eiOr10KG6PocCQdVhvA@mail.gmail.com>
 <20140519194156.GA5991@kroah.com>
 <537A685E.3040500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537A685E.3040500@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 11:23:58PM +0300, Emmanuel Grumbach wrote:
> 
> 
> On 05/19/2014 10:41 PM, Greg KH wrote:
> > On Mon, May 19, 2014 at 01:40:34PM +0300, Emmanuel Grumbach wrote:
> >> Hi,
> >>
> >> I need to disable a feature on 3.13 and 3.14. But I don't have any
> >> patch upstream that I can point to as the patch that needs to be
> >> backported.
> >> We have a feature that is buggy in 3.13 and 3.14. We refactored (and
> >> fixed) this feature in 3.15 but the refactor is really not stable
> >> material, so basically, I can't backport the fix to 3.13 / 3.14. A
> >> user reported that disabling the feature solved (part of) his issues:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=72601.
> >> OTOH, I don't have any patch in linux.git that could be backported to
> >> do what I want in 3.13 / 3.14 - i.e. disable the feature.
> >> What is the right process here? I understand that this isn't covered
> >> by the "stable rules". So what should I do here?
> > 
> > Get the maintainer's approval to apply this patch and I can queue it up.
> 
> Ok - thanks. It might be worthwhile to add this "exception path" in the Documentation :)

No, it's such a rare exception, I don't want to "encourage" anyone to
ever do it by documenting it.

thanks,

greg k-h

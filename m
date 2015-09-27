Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbbI0PFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 11:05:42 -0400
Date: Sun, 27 Sep 2015 08:03:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pinkesh Jain <pinkeshbadjatiya@gmail.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, carlos@cgarcia.org,
	linux-wireless@vger.kernel.org,
	rickard_strandqvist@spectrumdigital.se, luca@lucaceresoli.net,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	gdonald@gmail.com
Subject: Re: [PATCH] Removed extra spaces, and error from checkpatch.pl
Message-ID: <20150927150347.GA27003@kroah.com> (sfid-20150927_170634_956155_ACF487DE)
References: <20150927001415.GA34976@ubuntu>
 <20150927060352.GA1835@fool>
 <CACJZ1zqyVJ95GNWReSZ-C3hgjgA97LaJNna=pGkKC8ZQjzvnuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CACJZ1zqyVJ95GNWReSZ-C3hgjgA97LaJNna=pGkKC8ZQjzvnuA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 27, 2015 at 01:59:17PM +0530, Pinkesh Jain wrote:
> There were many warnings and error given by checkpatch.pl and most of them were
> almost of the same type so i believed a single patch is enough to do the
> cleanup.
> 
> 1. Remove errors of the struct declaration (foo*bar to foo *bar)
> 2. Removed warnings of 'spaces before comma'.
> 3. Added space after enum declaration and before opening of paranthesis.
> 4. removed spaces between function calls (func () to func() )
> 5. Still there are a lot of warnings related to only line lengths but removing
> then would not make sense and would leave the code unreadable.
> 
> There were one or two more of such kind of very small code refactoring that i
> did. Since they were not that important, also i 'Did Not Alter' any other part
> of functioning code so i made the changes in a single patch.
> 
> I am new here and this is my first patch so please give me  enough suggestions
> and reviews for what i do, so that i can get familiar with the community
> guidelines.
> 
> If i do anything wrong then please correct me.
> 
> Questions:
> 1.) Do i need to mention all this changes that i wrote about in the commit as
> they are very descriptive? I tried to be brief in the commit message.

Be descriptive.

> 2.) Do i need to split the changes in separate commits, as one of the members
> pointed out.

yes.

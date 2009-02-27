Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59285 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbZB0VpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:45:23 -0500
Date: Fri, 27 Feb 2009 16:32:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: John Daiker <daikerjohn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: airo_cs: checkpatch.pl cleanups
Message-ID: <20090227213247.GM3687@tuxdriver.com> (sfid-20090227_224526_282046_7F0DFB5D)
References: <49A5B88C.1020403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49A5B88C.1020403@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2009 at 01:30:52PM -0800, John Daiker wrote:
> Keeping this one simple again.
> 
> Before: 36 errors, 6 warnings, 482 lines checked
> After:  14 errors, 3 warnings, 484 lines checked
> 
> This was mainly 'trailing whitespace', a few 'over 80 character', and a couple 'spaces required' fixes.
> 
> md5sum's from before and after are identical.
> 
> John

I'm happy to have your patches, but you are complicating my life a
bit with your submissions.  Please review the information here:

	http://linux.yyz.us/patch-format.html

Note especially the Signed-off-by requirement.  Also, it would be
better for me if you could send the patches inline rather than as
attachements.  When doing so, please ensure that your mailer does
not damage whitespace in the patches.

Please resubmit this patch while following the guidelines above.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

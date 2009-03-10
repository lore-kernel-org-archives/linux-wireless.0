Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46235 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZCJVAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:00:31 -0400
Date: Tue, 10 Mar 2009 16:49:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: John Daiker <daikerjohn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] strip: checkpatch.pl cleanups
Message-ID: <20090310204908.GE10800@tuxdriver.com> (sfid-20090310_220034_711004_F8456498)
References: <49B4D53A.60801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49B4D53A.60801@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 09, 2009 at 01:37:14AM -0700, John Daiker wrote:
> strip: checkpatch.pl cleanups
> 
> Before: 110 errors, 135 warnings, 2800 lines checked
> After:  8 errors, 134 warnings, 2800 lines checked
> 
> Most fixes were "return is not a function, parenthesis are not
> required", trailing whitespace, and "spaces required around 'x'"
> 
> md5sums before and after are identical.
> 
> Signed-off-by: John Daiker <daikerjohn@gmail.com>

This had a ton of whitespace errors, and then didn't apply once I
tried to fix them all...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

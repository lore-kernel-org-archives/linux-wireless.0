Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:44534 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932391Ab3CMP3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 11:29:07 -0400
Date: Wed, 13 Mar 2013 11:28:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: jussi.kivilinna@iki.fi, alessandro.lannocca@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH for 3.9] rtlwifi: rtl8192cu: Fix problem that prevents
 reassociation
Message-ID: <20130313152853.GB10077@tuxdriver.com> (sfid-20130313_162910_932501_908DEEEC)
References: <51409b0d.AKkQggbo18xQwrFd%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51409b0d.AKkQggbo18xQwrFd%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 13, 2013 at 10:28:13AM -0500, Larry Finger wrote:
> The driver was failing to clear the BSSID when a disconnect happened. That
> prevented a reconnection. This problem is reported at
> https://bugzilla.redhat.com/show_bug.cgi?id=789605,
> https://bugzilla.redhat.com/show_bug.cgi?id=866786,
> https://bugzilla.redhat.com/show_bug.cgi?id=906734, and
> https://bugzilla.kernel.org/show_bug.cgi?id=46171.
> 
> Thanks to Jussi Kivilinna for making the critical observation
> that led to the solution.
> 
> Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Tested-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Tested-by: Alessandro Lannocca <alessandro.lannocca@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> ---
> 
> John,
> 
> As you can see by the number of bug reports, this patch should be
> pushed as soon as possible.
> 
> Thanks,
> 
> Larry

Got it -- disregard my earlier query... :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

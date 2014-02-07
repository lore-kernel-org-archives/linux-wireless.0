Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:41868 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaBGGzg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 01:55:36 -0500
Date: Fri, 7 Feb 2014 07:55:30 +0100
From: Gianluca Anzolin <gianluca@sottospazio.it>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: Re: BISECTED Re: 3.14-mw regression:  circular locking dependency
 (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81ad6344>]
 tty_lock_nested+0x44/0xa0
Message-ID: <20140207065530.GA30769@sottospazio.it> (sfid-20140207_075542_648963_9F992811)
References: <378824645.20140126114721@eikelenboom.it>
 <754206689.20140207013750@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <754206689.20140207013750@eikelenboom.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sander,

On Fri, Feb 07, 2014 at 01:37:50AM +0100, Sander Eikelenboom wrote:
> Hi Marcel / Gianluca,
> 
> Bisection points to this commit:
> 
> 4a2fb3ecc7467c775b154813861f25a0ddc11aa0 is the first bad commit
> commit 4a2fb3ecc7467c775b154813861f25a0ddc11aa0
> Author: Gianluca Anzolin <gianluca@sottospazio.it>
> Date:   Mon Jan 6 21:23:52 2014 +0100

Thank you for you report. I'm aware of this bug, no need to investigate
further.

This and other bugs are being tackled by Peter Hurley, who knows the tty
code way better than me.

You just have to wait for his patches, I think they will come shortly.

Thank you,

Gianluca

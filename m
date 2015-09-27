Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34742 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbI0GEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 02:04:05 -0400
Date: Sun, 27 Sep 2015 11:33:52 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Pinkesh Badjatiya <pinkeshbadjatiya@gmail.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org, gdonald@gmail.com,
	luca@lucaceresoli.net, rickard_strandqvist@spectrumdigital.se,
	carlos@cgarcia.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removed extra spaces, and error from checkpatch.pl
Message-ID: <20150927060352.GA1835@fool> (sfid-20150927_080449_251924_0A51EE55)
References: <20150927001415.GA34976@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150927001415.GA34976@ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 27, 2015 at 05:44:16AM +0530, Pinkesh Badjatiya wrote:
> Removed trailing spaces.
> Fixed some errors from checkpatch.pl verification.
> No changes made to actual functional code.
> 
> Signed-off-by: Pinkesh Badjatiya <pinkeshbadjatiya@gmail.com>
> ---
And you have done more than one change in this patch. Please do only
one type of change in a patch and mention the change in the commit
message.

Regards
Sudip

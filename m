Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59146 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102AbZBZJKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 04:10:46 -0500
Date: Thu, 26 Feb 2009 11:10:37 +0200
From: Jouni Malinen <j@w1.fi>
To: pat-lkml <pat-lkml@erley.org>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k and TKIP hw crypto in AP mode
Message-ID: <20090226091037.GA10941@jm.kir.nu> (sfid-20090226_101051_347290_997EC722)
References: <20090224114201.GB21933@jm.kir.nu> <49A40320.1040902@erley.org> <20090224150710.GA1419@jm.kir.nu> <49A41315.3030007@erley.org> <49A45378.50009@erley.org> <20090225181953.GA23880@jm.kir.nu> <49A5D83A.1090602@erley.org> <49A5DDED.1080408@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49A5DDED.1080408@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2009 at 07:10:21PM -0500, pat-lkml wrote:
> pat-lkml wrote:
> > I had to make some changes to get it to build, am going to test shortly.

Ah.. I had made the patch on top of number of other changes and did not
remember to rebase it on top of wireless-testing.

> And it appears to be working.  I have it set to 10 minute rekeying, so I'll
> have more success/failure for you then (and am waiting to send this e-mail
> until then).
> 
> Well, it rekey'd with no interruption in service.  I'd call it a success.

Thanks, nice to hear. I was also able to complete testing on this with
both the newer and older hardware revisions and both for AP and STA
modes.

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38978 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZA2Euo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 23:50:44 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 20:50:44 -0800
Date: Wed, 28 Jan 2009 20:50:00 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: pat-lkml <pat-lkml@erley.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH resend] crda: rename nl_handle to nl_sock for libnl-2.0
Message-ID: <20090129045000.GA30318@tesla> (sfid-20090129_055048_760124_C19B9722)
References: <4980EDC8.4050204@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4980EDC8.4050204@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 03:44:08PM -0800, pat-lkml wrote:
> Upstream has renamed nl_handle to nl_sock.  Update crda to the new names
> and add #define for libnl-1.1.
> 
> Signed-off-by: Pat Erley <pat-lkml@erley.org>
> ---
> 
> I'm not too proud to admit that I did proofread this, twice, and still
> missed changing iw to crda in the commit message.
> 
> In the future, should I keep pushing these sorts of patches, or should
> we back them out and wait for a 'release' of libnl-2.0 and push them all
> in then?

I'll gladly take them, sure, actually thanks!

  Luis

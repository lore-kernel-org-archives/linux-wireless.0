Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:37299 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753863AbYDFPzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 11:55:08 -0400
Date: Sun, 6 Apr 2008 17:54:34 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: fix bcm4303 crash
Message-ID: <20080406175434.5f1e45b4@polimi.it> (sfid-20080406_165524_992308_5C2AD3DA)
In-Reply-To: <200804061720.02381.mb@bu3sch.de>
References: <20080406170507.16992935@polimi.it>
	<200804061720.02381.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 6 Apr 2008 17:20:02 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> On Sunday 06 April 2008 17:05:07 Stefano Brivio wrote:
> > This fixes an hard crash which happened upon driver loading on bcm4303 rev.
> > 2 devices.
> > 
> > Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> 
> ACK
> 
> > ---
> > John, this is for 2.6.26.
> 
> Why not 2.6.25?

Sorry, typo. Yes, i meant 2.6.25.


--
Ciao
Stefano

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3941 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbYFOBDP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 21:03:15 -0400
Date: Sat, 14 Jun 2008 20:40:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH stable] b43: Fix possible NULL pointer dereference in
	DMA code
Message-ID: <20080615004018.GA1396@tuxdriver.com> (sfid-20080615_030319_448978_4CCAC131)
References: <200806142257.55946.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200806142257.55946.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 14, 2008 at 10:57:55PM +0200, Michael Buesch wrote:
> This fixes a possible NULL pointer dereference in an error path of the
> DMA allocation error checking code. In case the DMA allocation address is invalid,
> the dev pointer is dereferenced for unmapping of the buffer.
> 
> This is a cut-down version of 3ab4b64c46784ed83f213bf4e1b51d9c55858600
> which is upstream in John Linville's wireless-testing.git tree.

...which will probably be 028118a5f09a9c807e6b43e2231efdff9f224c74
in linux-2.6.git

John
-- 
John W. Linville
linville@tuxdriver.com

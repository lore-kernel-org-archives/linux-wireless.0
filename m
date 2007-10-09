Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2974 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbXJIVmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 17:42:25 -0400
Date: Tue, 9 Oct 2007 17:21:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: fix warning about adhoc_rates_b
Message-ID: <20071009212107.GB3175@tuxdriver.com> (sfid-20071009_224231_967860_556E7CAD)
References: <200710081135.39640.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710081135.39640.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 08, 2007 at 11:35:39AM +0200, Holger Schurig wrote:
> Patch d2b5c42a113ab03cf32acb99b408041264915e97 made libertas 
> advertise g rades, so remove the now unused b rates.

Identical patch is already in net-2.6.24.

John
-- 
John W. Linville
linville@tuxdriver.com

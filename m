Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39740 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbXLCUtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 15:49:07 -0500
Subject: Re: [PATCH] less eventcause shifts
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1196704681.21151.13.camel@localhost.localdomain>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196704681.21151.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 20:48:59 +0000
Message-Id: <1196714939.13978.171.camel@pmac.infradead.org> (sfid-20071203_204912_097320_1EEB4C8D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-03 at 12:58 -0500, Dan Williams wrote:
> I'm sort of sitting on these patches until you and Woodhouse start using
> the same git tree until he's done with the command rework...  It's going
> to be near impossible to handle both of your patches with any certainty.
> Any progress on whether you've both been able to work in the same repo?

http://git.infradead.org/?p=libertas-2.6.git

It's based on Linus' tree -- we've abandoned John's wireless-dev tree
altogether. He rebases it and uses branches -- it's just an exercise in
making git hard.

-- 
dwmw2


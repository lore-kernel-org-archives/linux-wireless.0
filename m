Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47204 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0FRSpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 14:45:12 -0400
Date: Fri, 18 Jun 2010 14:44:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kurt Garloff <garloff@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WLAN Regulatory Domain Germany
Message-ID: <20100618184431.GD6282@tuxdriver.com>
References: <20100519172944.GB32757@tpkurt2.garloff.de>
 <1274690246.3743.20.camel@jlt3.sipsolutions.net>
 <20100525151429.GC6342@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20100525151429.GC6342@tpkurt2.garloff.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 25, 2010 at 05:14:29PM +0200, Kurt Garloff wrote:

> OK, new suggestion.
> 
> 8<------------------------------------------------------------------------                    
> 
> # Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from
> # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
> # For the 5GHz range also see
> # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publicationFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
> # The values have been reduced by a factor of 2 (3db) for non TPC devices
> # (in other words: devices with TPC can use twice the tx power of this table).
> # Note that the docs do not require TPC for 5150--5250; the reduction to
> # 100mW thus is not strictly required -- however the conservative 100mW
> # limit is used here as the non-interference with radar and satellite
> # apps relies on the attenuation by the building walls only in the
> # absence of DFS; the neighbour countries have 100mW limit here as well.
> 
> country DE:
> 	# entries 279004 and 280006
>        (2400 - 2483.5 @ 40), (N/A, 100 mW)
>        # entry 303005
>        (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
>        # entries 304002 and 305002
>        (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
>        # entries 308002, 309001 and 310003
>        (5470 - 5725 @ 40), (N/A, 500 mW), DFS
> 
> 8<------------------------------------------------------------------------

Is this what we want?  Are you going to submit an actual patch?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

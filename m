Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24100 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZG2V3S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:29:18 -0400
Subject: Re: ar9170 DWA 160A
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	otus-devel@lists.madwifi-project.org,
	Felix Bitterli <ic.felix@gmail.com>
In-Reply-To: <43e72e890907281646x731bfcc3v62f17e21bd94bb4@mail.gmail.com>
References: <43e72e890907281646x731bfcc3v62f17e21bd94bb4@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 17:29:15 -0400
Message-Id: <1248902955.4253.10.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-28 at 16:46 -0700, Luis R. Rodriguez wrote:
> We have these listed on ar9170 wiki page as under Dlink DWA160A:
> 
> 0x07d1:0x3c10
> 0x0846:0x9010
> 
> A user just reported thy purchased DWA160 by mistake thinking it was
> the same but it turns out it has some other wireless chipset. Do any
> of you have a DWA160A that is claimed by ar9170 or should we remove
> this from the list?

The D-Link site doesn't mention DWA160A or DWA-160A at all.  It has
DWA-160 only.  When downloading the drivers, there is a choice between
"DWA-160" and "DWA-160_REVB".  The former has Atheros drivers, the later
has rt2870.

I guess the original "DWA-160" was "rev A", so it could have transformed
to "DWA-160A" somewhere.  That said, the online retailers sell "DWA-160"
and not "DWA-160A".

I think we can write that DWA-160 rev A is supported by ar9170 and
DWA-160 rev B is supported by rt2870 in the staging tree.

-- 
Regards,
Pavel Roskin

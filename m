Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40121 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbZKRPAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:00:25 -0500
Date: Wed, 18 Nov 2009 09:45:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: 
Message-ID: <20091118144557.GB2911@tuxdriver.com>
References: <1258509054-10901-1-git-send-email-janakiram.sistla@gmail.com> <1258541631.30511.7.camel@johannes.local> <20091118134402.GA2911@tuxdriver.com> <4fb5db50911180619j6d3e6815i40602f0232b8e472@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4fb5db50911180619j6d3e6815i40602f0232b8e472@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 07:49:30PM +0530, Janakiram Sistla wrote:
> On Wed, Nov 18, 2009 at 7:14 PM, John W. Linville

> > P.S.  Hmmm...anyone want to add a kerneldoc entry for RFKILL_TYPE_GPS?
> Can i add this ???

Sure, but please do a different patch for that.  Make it the first
one, so that it can be applied even if there is still a problem with
the other patch.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

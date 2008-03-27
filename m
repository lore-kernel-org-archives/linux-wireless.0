Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2331 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798AbYC0VU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 17:20:28 -0400
Date: Thu, 27 Mar 2008 16:53:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
Subject: Re: [PATCH] iwlwifi: do not register bands with no supported
	channels
Message-ID: <20080327205359.GA17267@tuxdriver.com> (sfid-20080327_212033_114035_138E5A5D)
References: <1206475120-10188-1-git-send-email-linville@tuxdriver.com> <1ba2fa240803251331y60f3cf58x8f08bd4411b1369d@mail.gmail.com> <20080325212407.GB20488@tuxdriver.com> <1ba2fa240803251645r1f034c5enf880c0ffbb830a1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240803251645r1f034c5enf880c0ffbb830a1a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 26, 2008 at 01:45:03AM +0200, Tomas Winkler wrote:

> >  I don't think your version will resolve the issue.  Am I missing
> >  something?
> 
> Yep I was a bit snappy. my suggestion doesn't resolve the problem.
> Anyhow, let me look at this tomorrow if we have other SKU issues so it
> can be rolled in together.

I'm going to go ahead and push mine with todays patches.  Feel free
to correct it later if there is some more appropriate test.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42767 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab2HMTAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 15:00:14 -0400
Date: Mon, 13 Aug 2012 14:50:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Vladimir Zapolskiy <vz@mleia.com>, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcm80211: smac: set interface down on reset
Message-ID: <20120813185042.GD10529@tuxdriver.com> (sfid-20120813_210019_299270_81458A16)
References: <1344115747-25627-1-git-send-email-vz@mleia.com>
 <50201D62.2020701@mleia.com>
 <50201EDD.30408@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50201EDD.30408@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 06, 2012 at 09:45:33PM +0200, Arend van Spriel wrote:
> On 08/06/2012 09:39 PM, Vladimir Zapolskiy wrote:
> > Hi Arend,
> > 
> > what do you think about the proposed change? For me the problem is
> > quite severe, for the last several months I had to patch the kernel
> > to have functional BCM43225 on my laptop, hopefully the fix should go to
> > the
> > stable branches as well.
> > 
> 
> I have forwarded it to my colleagues. I may want to revise the fix  a
> little and have it applied to stable as well. I was not aware that this
> scenario occurs frequently. Thanks for addressing your issue so
> proactively ;-)

Any word on the state of this fix?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

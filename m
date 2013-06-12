Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49748 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab3FLWAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 18:00:10 -0400
Date: Wed, 12 Jun 2013 17:57:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-06-05
Message-ID: <20130612215731.GB906@tuxdriver.com> (sfid-20130613_000016_645545_2AD11173)
References: <1370415743.8920.6.camel@jlt4.sipsolutions.net>
 <1371039449.8601.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371039449.8601.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 12, 2013 at 02:17:29PM +0200, Johannes Berg wrote:
> Amending this ...
> 
> 
> I picked up Nikolay's patch for the chain noise calibration bug that
> seems to have been there forever, a fix from Emmanuel for setting TX
> flags on BAR frames and a fix of my own to avoid printing
> request_module() errors if the kernel isn't even modular. We also have
> our own version of Stanislaw's fix for rate control.
> 
> johannes
> 
> The following changes since commit a87783699b23395c46bbeeb5d28f6db24897bf26:
> 
>   iwlwifi: dvm: fix zero LQ CMD sending avoidance (2013-05-27 11:33:57 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to 622ebe994f6866b8d46ee5d3bcc329ed65d3722d:
> 
>   iwlwifi: fix rate control regression (2013-06-12 14:13:39 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

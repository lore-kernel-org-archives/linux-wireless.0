Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34541 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1BPOph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 09:45:37 -0500
Date: Wed, 16 Feb 2011 09:41:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: wwguy <wey-yi.w.guy@intel.com>, Nathaniel Smith <njs@pobox.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: [PATCH 1/5] iwlwifi: Simplify tx queue management
Message-ID: <20110216144129.GA10287@tuxdriver.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
 <1297619803-2832-2-git-send-email-njs@pobox.com>
 <1297677453.3785.4.camel@jlt3.sipsolutions.net>
 <AANLkTinA0yoF_dU+2B6+rHcE_DvS7yjqu+TqYzhprvZj@mail.gmail.com>
 <1297723541.4723.22.camel@wwguy-ubuntu>
 <20110216091605.GA2812@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110216091605.GA2812@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 16, 2011 at 10:16:06AM +0100, Stanislaw Gruszka wrote:
> On Mon, Feb 14, 2011 at 02:45:41PM -0800, wwguy wrote:
> > btw, we are in the process of splitting 3945/4965 out of iwlwifi into it
> > own directory (iwlwifilegacy). 
> Uhh, we do not have suchlongdrivernames in kernel, what about iwlegacy :-)

I do prefer iwlegacy to iwlwifilegacy as well...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

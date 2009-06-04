Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53419 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZFDApg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 20:45:36 -0400
Date: Wed, 3 Jun 2009 20:41:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, yi.zhu@intel.com
Subject: Re: [PATCH] cfg80211: fix Kconfig for users of cfg80211
Message-ID: <20090604004127.GA2228@tuxdriver.com>
References: <1244046631.4862.34.camel@johannes.local> <1244073490.2723.3.camel@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244073490.2723.3.camel@sortiz-mobl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 04, 2009 at 01:58:09AM +0200, Samuel Ortiz wrote:
> Hi Johannes
> 
> On Wed, 2009-06-03 at 18:30 +0200, Johannes Berg wrote:
> > * iwm doesn't depend on cfg80211 or wireless extensions
> This one will conflict with a patch Yi sent a week ago.
> Dave Miller applied it to his net-next-2.6 tree, commit
> d0fc1d5e3fe869f8a32a2bc1dd02d8383a057164.
> See also:
> http://marc.info/?l=linux-wireless&m=124331653022408&w=2

Don't worry, I have the conflict resolved in wireless-next-2.6...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

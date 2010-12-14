Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58113 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759278Ab0LNPZm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 10:25:42 -0500
Subject: Re: [PATCH 06/14] iwlagn: rename enhanced txpower fields
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1292311038.3569.4.camel@jlt3.sipsolutions.net>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1292285372-11373-7-git-send-email-wey-yi.w.guy@intel.com>
	 <1292311038.3569.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Tue, 14 Dec 2010 07:24:33 -0800
Message-Id: <1292340273.9665.2.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Mon, 2010-12-13 at 23:17 -0800, Johannes Berg wrote:
> On Mon, 2010-12-13 at 16:09 -0800, Wey-Yi Guy wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Some fields we didn't previously use from the
> > enhanced TX power structure will be needed in
> > the next patch, so rename them to their correct
> > names to be able to use them and change code
> > reading them accordingly.
> 
> Would probably be better to get this and the 7/14 patch by merging
> wireless-2.6, rather than applying the patch again.
> 
THat was my original plan, but the patch apply to wireless-2.6 is not
exactly the same as the one apply to wireless-next-2.6 since there are
number of patches apply to the same area. 

Also if holding those 2 patches, I am also holding a lot of other
patches following.

Wey


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2084 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbYDHSbY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 14:31:24 -0400
Date: Tue, 8 Apr 2008 14:01:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: Jason Riedy <jason@acm.org>, Tomas Winkler <tomasw@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [PATCH] Remove most references to iwl4965-only
	features from iwl3945.
Message-ID: <20080408180127.GA8183@tuxdriver.com> (sfid-20080408_193129_876426_CA23DBAB)
References: <87prt86jfu.fsf@sparse.dyndns.org> <D936D925018D154694D8A362EEB0892004194D33@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D936D925018D154694D8A362EEB0892004194D33@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 02, 2008 at 04:38:57PM -0700, Chatre, Reinette wrote:
> On Wednesday, April 02, 2008 2:22 PM,
> linux-wireless-owner@vger.kernel.org  wrote:
> 
> > And Tomas Winkler writes:
> >> This one is not supported in 3945 for real.
> > 
> > Someone with access to the documentation should rip the 4965-only
> > pieces out of the 3945-only driver...
> 
> This is work that has already started. For a clear example see
> http://marc.info/?l=linux-wireless&m=120613337428006&w=2.

I'm dropping this patch -- I'm confused if it all should be dropped
or just part.

Please repost any portions which need to be applied.

John
-- 
John W. Linville
linville@tuxdriver.com

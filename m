Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4180 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYF3ORS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 10:17:18 -0400
Date: Mon, 30 Jun 2008 09:55:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>
Subject: Re: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
Message-ID: <20080630135539.GA6864@tuxdriver.com> (sfid-20080630_161720_997252_8F6FB03E)
References: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com> <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com> <1ba2fa240806300152o6d5f7deby6d00a4421138177c@mail.gmail.com> <43e72e890806300159j6c98ef9dpeac61d5aeca19f0e@mail.gmail.com> <1214817730.5507.27.camel@johannes.berg> <1ba2fa240806300425i609ababfj22a76718d3857f85@mail.gmail.com> <1214825747.5507.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214825747.5507.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 01:35:47PM +0200, Johannes Berg wrote:
> On Mon, 2008-06-30 at 14:25 +0300, Tomas Winkler wrote:
> 
> > The idea was ask troubled user to make change in modprobe.conf and not
> > changing the code.
> 
> Yeah but IMHO you're solving the wrong problem. If we want any
> credibility we shouldn't allow users to ignore any regdom that easily,
> and this is system-wide.

I share this opinion.  I'm not inclined to merge this patch.

-- 
John W. Linville
linville@tuxdriver.com

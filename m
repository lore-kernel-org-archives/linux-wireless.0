Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbXK1P2i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 10:28:38 -0500
Subject: Re: [PATCH] less eventcause shifts
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200711281613.51463.hs4233@mail.mn-solutions.de>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196261611.28264.0.camel@localhost.localdomain>
	 <1196262129.30806.26.camel@pmac.infradead.org>
	 <200711281613.51463.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 10:22:45 -0500
Message-Id: <1196263365.28264.33.camel@localhost.localdomain> (sfid-20071128_152855_664199_B2C3E23A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-11-28 at 16:13 +0100, Holger Schurig wrote:
> > s/less/fewer/ of course :)
> 
> Thanks. Should I re-submit?
> 
> 
> > Since I'm also going to be sending a flurry of libertas
> > patches and the turnaround through the wireless tree seems
> > suboptimal, shall we put up a git tree and work on it
> > together, then ask John to pull when we're done?
> 
> That might be an option. Currently, I'm working with 
> wireless-2.6/everything and quilt (because it's faster then 
> stgit).
> 
> My goal with libertas is better roaming in an STA+MANY APs 
> scenario. Right now libertas is almost unusable for my usage 
> work type. The new-scan patch is just a stepstone in this 
> direction (so that I understand scanning much better). Also my 
> janitor-like patches are just by-products of getting used to the 
> code-base.
> 
> In what parts of libertas are you working?

He's reworking the firmware command handling to not be quite as sucky
and obfuscated.  It's gonna be a big patch.

Dan



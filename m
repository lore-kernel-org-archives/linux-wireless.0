Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:8880 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbXK1PM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 10:12:59 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] less eventcause shifts
Date: Wed, 28 Nov 2007 16:13:51 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
References: <200711280915.11300.hs4233@mail.mn-solutions.de> <1196261611.28264.0.camel@localhost.localdomain> <1196262129.30806.26.camel@pmac.infradead.org>
In-Reply-To: <1196262129.30806.26.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711281613.51463.hs4233@mail.mn-solutions.de> (sfid-20071128_151308_733387_FF06E645)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> s/less/fewer/ of course :)

Thanks. Should I re-submit?


> Since I'm also going to be sending a flurry of libertas
> patches and the turnaround through the wireless tree seems
> suboptimal, shall we put up a git tree and work on it
> together, then ask John to pull when we're done?

That might be an option. Currently, I'm working with 
wireless-2.6/everything and quilt (because it's faster then 
stgit).

My goal with libertas is better roaming in an STA+MANY APs 
scenario. Right now libertas is almost unusable for my usage 
work type. The new-scan patch is just a stepstone in this 
direction (so that I understand scanning much better). Also my 
janitor-like patches are just by-products of getting used to the 
code-base.

In what parts of libertas are you working?

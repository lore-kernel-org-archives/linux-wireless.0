Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:52560 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199Ab0JEW3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 18:29:46 -0400
Date: Wed, 6 Oct 2010 00:29:44 +0200
From: Florian Mickler <florian@mickler.org>
To: stable@kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwl3945: queue the right work if the scan needs to be
 aborted
Message-ID: <20101006002944.4545cf32@schatten.dmk.lab>
In-Reply-To: <20101005104357.GB18833@redhat.com>
References: <20101005084305.52a31ed4@schatten.dmk.lab>
	<20101005085717.GA18012@redhat.com>
	<20101005121242.79cdafc2@schatten.dmk.lab>
	<20101005104357.GB18833@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 5 Oct 2010 12:43:58 +0200
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> > > 
> > > However, I do not think we should go with that to -stable (below
> > > 2.6.36). IIRC warnings showed up in current 2.6.36-rc, because of
> > > some other changes in the code.
> > > 
> > > Stanislaw
Hello stable,

scrap this. I handed out a brown paper bag bug fix and if that doesn't
get into 2.6.36, it probably should go into 2.6.36.y. But let's see...

Regards,
Flo

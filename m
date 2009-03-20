Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33291 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbZCTOpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 10:45:42 -0400
Date: Fri, 20 Mar 2009 10:36:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Abbas, Mohamed" <mohamed.abbas@intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 06/13] iwlcore: Fix scan problem, resource busy
Message-ID: <20090320143647.GA5655@tuxdriver.com> (sfid-20090320_154546_968562_295BF92E)
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com> <1237351913-19202-6-git-send-email-reinette.chatre@intel.com> <1237351913-19202-7-git-send-email-reinette.chatre@intel.com> <200903191712.01325.helmut.schaa@gmail.com> <26E9B811E137AB4B95200FD4C950886B25DDE919@orsmsx507.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <26E9B811E137AB4B95200FD4C950886B25DDE919@orsmsx507.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2009 at 12:58:43PM -0700, Abbas, Mohamed wrote:
> Yes if mac80211 is fixed to accept failure then this patch not
> needed. I did not get is there us a patch that already fix this or
> I need to do it myself.

I think it is fixed already.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

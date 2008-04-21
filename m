Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:55507 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYDUStO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 14:49:14 -0400
Date: Mon, 21 Apr 2008 14:49:11 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kyle McMartin <kyle@mcmartin.ca>,
	linux-wireless@vger.kernel.org
Subject: Re: iwl4965: slow scans
Message-ID: <20080421184911.GB19802@phobos.i.cabal.ca> (sfid-20080421_205004_703357_5F7FC8EF)
References: <20080421160318.GA19802@phobos.i.cabal.ca> <20080421174122.GA10857@tuxdriver.com> <1208800976.32409.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1208800976.32409.0.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 21, 2008 at 02:02:56PM -0400, Dan Williams wrote:
> Yeah, could be an NM issue or a supplicant issue I guess.  Or, even if
> the card _is_ returning scan results, it might not be returning results
> for your AP.
> 

I'm also poking the card with iwlist with NM off, and still see huge
delays waiting for the network to show up.

> Do you have hardware or software scanning on (ie, is disable_hw_scan
> module option 1 or 0?)
> 

It's pretty invariant... disable_hw_scan=1 seems to be a bit faster, but
also breaks the second suspend, unless you unload the module first.

regards, Kyle

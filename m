Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50603 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbaJaIpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 04:45:15 -0400
Message-ID: <1414745106.3014.17.camel@jlt4.sipsolutions.net> (sfid-20141031_094617_783366_67F54E13)
Subject: Re: iwlwifi: mvm:  BACKPORT_WANT_DEV_COREDUMP?
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Fri, 31 Oct 2014 09:45:06 +0100
In-Reply-To: <1414744834.1964.7.camel@x220> (sfid-20141031_094119_721260_FECF8114)
References: <1414744834.1964.7.camel@x220>
	 (sfid-20141031_094119_721260_FECF8114)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-31 at 09:40 +0100, Paul Bolle wrote:
> Your commit aadede6e9f4c ("iwlwifi: mvm: port to devcoredump framework")
> landed in today's linux-next (next-20141031). It adds a select statement
> for BACKPORT_WANT_DEV_COREDUMP. There's no Kconfig symbol 
> BACKPORT_WANT_DEV_COREDUMP so this select is currently a nop. (In
> https://lkml.org/lkml/2014/9/30/578 I proposed a patch that emits a
> warning in cases like this.)
> 
> Did you perhaps meant to select WANT_DEV_COREDUMP?

Yes. We'll fix it up in the iwlwifi tree.

Thanks for the report!

johannes


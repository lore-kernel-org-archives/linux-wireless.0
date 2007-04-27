Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:44461 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755995AbXD0PaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:30:07 -0400
Message-ID: <463216FA.6000206@warmcat.com>
Date: Fri, 27 Apr 2007 16:30:02 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Dan Williams <dcbw@redhat.com>,
	Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>	<200704251634.16604.flamingice@sourmilk.net>	<46312067.9090005@linux.intel.com>	<200704262023.52833.flamingice@sourmilk.net>	<1177684132.21025.36.camel@localhost.localdomain>	<20070427164208.25434f11@griffin.suse.cz>	<1177685793.21025.52.camel@localhost.localdomain> <20070427172004.32b7bf4a@griffin.suse.cz>
In-Reply-To: <20070427172004.32b7bf4a@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:

> fixes the problem. Now, let's find something that fixes the problem as
> well but doesn't remove the functionality. James already proposed a
> solution that could work if a support for user space MLME is added. Do
> you have an idea how to add it?

Jiri, what functionality?  The ability to change frequency periodically?
  Isn't that something mac80211 can do already?

What is the special sauce that just HAS to be in vendor firmware here?

-Andy

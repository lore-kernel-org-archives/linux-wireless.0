Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56812 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaACUpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 15:45:15 -0500
Date: Fri, 3 Jan 2014 15:35:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2013_12_31
Message-ID: <20140103203515.GB6353@tuxdriver.com> (sfid-20140103_214521_009651_89C1F4D9)
References: <52C2FB68.2010708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 31, 2013 at 07:14:16PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is probably the last pull request for 3.14.
> 
> I have here a rework of the interrupt handling to meet RT kernel
> requirements - basically we don't take any lock in the primary interrupt
> handler. This gave me a good reason to clean things up a bit on the way.
> There is also a fix of the QoS mapping along with a few workarounds for
> hardware / firmware issues that are hard to hit.
> Three fixes suggested by static analyzers, and other various stuff.
> Most importantly, I update the Copyright note to include the new year.
> 
> I know it is quite late in the cycle (and probably not the best period
> to expect responsiveness:)) but I want to hope that this it will still
> make it to 3.14.
> 
> The following changes since commit cf4ef65446443eb485afe9419ea82b2efbe582a7:
> 
>   iwlwifi: mvm: rs: fix variable shadowing (2013-12-17 22:32:57 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> for-john
> 
> for you to fetch changes up to 14648d6534477952633ee3ecadb31cf227414f13:
> 
>   iwlwifi: mvm: fix coccinelle warnings (2013-12-31 19:03:53 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

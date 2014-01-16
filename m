Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46232 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaAPSAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 13:00:18 -0500
Date: Thu, 16 Jan 2014 12:58:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: pull request: iwlwifi-next 2014_1_12
Message-ID: <20140116175842.GB10165@tuxdriver.com> (sfid-20140116_190021_689651_A49945AB)
References: <52D44A46.4000805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 13, 2014 at 10:19:18PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is the last pull request for 3.14 - (exact same beginning as my
> last pull request :)).
> I have here a bunch of things that accumulated since my last pull request.
> 
> Besides a few trivial patches, I have an important workaround for a HW
> issue that has kept me busy for a long time. Along with it, a fix that
> prevents an error from being printed.
> Eyal fixes our behavior against SISO APs and Ilan fixes an issue with
> multiple interface scenarios.
> Eliad fixes an error path in our init flow.
> We also have a few "static analyzers" fix.
> 
> I want to hope that this makes it to 3.14 through net-next.git. If not,
> I'll have to sent a few of them to net.git which is not a big disaster.
> 
> The following changes since commit 14648d6534477952633ee3ecadb31cf227414f13:
> 
>   iwlwifi: mvm: fix coccinelle warnings (2013-12-31 19:03:53 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> for-john
> 
> for you to fetch changes up to cf38e4f756d6396657c76f72ef42b6f47c523f97:
> 
>   iwlwifi: mvm: don't use highest rate in VHT MCS Set (2014-01-13
> 22:17:22 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

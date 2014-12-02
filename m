Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53109 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980AbaLBWAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 17:00:12 -0500
Date: Tue, 2 Dec 2014 16:56:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2014-12-02
Message-ID: <20141202215634.GF19024@tuxdriver.com> (sfid-20141202_230016_101052_E4606CC6)
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 02, 2014 at 06:05:39PM +0000, Grumbach, Emmanuel wrote:
> Hi John,
> 
> This is a last pull request with content for 3.19. As usual, the details are below.
> 
> Thanks!
> 
> The following changes since commit dcad8e4299bf81f8795b44677036dfa490c9fb15:
> 
>   iwlwifi: update the secure mem space and for the CPUs (2014-11-24 08:30:44 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-john-2014-12-02
> 
> for you to fetch changes up to 61df750cb00b69882ba3acbb82e9368d01119c93:
> 
>   iwlwifi: mvm: Ability to work with packed usniffer image (2014-12-02 16:51:56 +0200)
> 
> ----------------------------------------------------------------
> I deprecate here -8.ucode since -9 has been published long ago.
> Along with that I have a new activity, we have now better
> a infrastructure for firmware debugging. This will allow to
> have configurable probes insides the firmware.
> Luca continues his work on NetDetect, this feature is now
> complete. All the rest is minor fixes here and there.

Pulled...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

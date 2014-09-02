Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35820 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaIBPai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 11:30:38 -0400
Date: Tue, 2 Sep 2014 11:30:35 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-firmware@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: new firmware for 7260 / 7265 / 3160: 25.222.9.0
Message-ID: <20140902153035.GG15412@merlin.infradead.org> (sfid-20140902_173041_512689_25B16057)
References: <54057C59.4020807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54057C59.4020807@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 02, 2014 at 11:14:17AM +0300, Emmanuel Grumbach wrote:
> Dear linux-firmware.git maintainers,
> 
> Intel released a new -9 firmware for its WiFi adpaters for the 7000 family.
> No new features here, but only bug fixes.
> 
> The following changes since commit e2844339cb779c00f856c554958e16beca99b462:
> 
>   iwlwifi: update firmware for 3160 / 7260 / 7265 (2014-05-19 14:45:28 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.git master
> 
> for you to fetch changes up to e302d06fb8cd3ceade38ce484636094b1cd25a23:
> 
>   iwlwifi: update firmware for 3160 / 7260 / 7265 (2014-09-02 11:06:42 +0300)
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: update firmware for 3160 / 7260 / 7265
> 
>  WHENCE               |   6 +++---
>  iwlwifi-3160-9.ucode | Bin 666792 -> 669156 bytes
>  iwlwifi-7260-9.ucode | Bin 679380 -> 681464 bytes
>  iwlwifi-7265-9.ucode | Bin 691960 -> 697012 bytes
>  4 files changed, 3 insertions(+), 3 deletions(-)
> 

thanks, i'll get to this today.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51706 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbcCJStg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 13:49:36 -0500
Date: Thu, 10 Mar 2016 13:49:34 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-firmware@kernel.org
Subject: Re: pull request: iwlwifi -21.ucode firmware
Message-ID: <20160310184933.GA21789@merlin.infradead.org> (sfid-20160310_194940_390973_5AEAC807)
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA66A24@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA66A24@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 10, 2016 at 07:29:15AM +0000, Grumbach, Emmanuel wrote:
> Hi Kyle,
> 
> This is a pull request to include our latest available firmware into
> mainline linux-firmware.git.
> 
> It includes -21.ucode for various devices including devices for which
> this is the first supported firmware (3168 and 8265).
> This firmware is supported starting kernel 4.6.
> 
> Please pull!
> 

Pulled, can you follow this up and update WHENCE? I'd do it, but there's
a lack of consistency between Version: and some of the past commit
messages, so I'm not sure what the right value would be.

regards, --Kyle

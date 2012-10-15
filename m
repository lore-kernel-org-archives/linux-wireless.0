Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44596 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2JOSat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 14:30:49 -0400
Date: Mon, 15 Oct 2012 14:27:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/7] miscellaneous fixes intended for 3.7
Message-ID: <20121015182756.GE16817@tuxdriver.com> (sfid-20121015_203052_854710_CE6F6140)
References: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2012 at 11:13:05AM -0700, Franky Lin wrote:
> Here are some miscellaneous brcmfmac bug fix patches aiming for 3.7
> 
> Arend van Spriel (1):
>   brcmfmac: remove 'always false' condition from brcmf_c_mkiovar_bsscfg
> 
> Dan Carpenter (2):
>   brcmfmac: Using zero instead of NULL
> 
> Franky Lin (3):
>   brcmfmac: fix sparse warnings

These don't strike me as meaningful bug fixes.  I'll hold them for 3.8.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

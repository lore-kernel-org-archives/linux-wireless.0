Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:63516 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbbFHV06 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 17:26:58 -0400
Date: Mon, 8 Jun 2015 23:26:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, rupran@einserver.de, stefan.hengelein@fau.de
Subject: Re: [PATCH] drivers/nfc: remove obsolete setting of DEBUG
Message-ID: <20150608212654.GE5089@ribalta.mp.intel.com> (sfid-20150608_232720_676339_4843FA1F)
References: <1430212127-5841-1-git-send-email-valentinrothberg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430212127-5841-1-git-send-email-valentinrothberg@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Valentin,

On Tue, Apr 28, 2015 at 11:08:47AM +0200, Valentin Rothberg wrote:
> The CPP identifier 'DEBUG' is not used in the source code of nfc at all,
> so we can safely remove setting it in both Makefiles.
> 
> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
> ---
> I detected this issue with ./scripts/checkkconfigsymbols.py since
> CONFIG_NFC_DEBUG is not defined in Kconfig.
> ---
>  drivers/nfc/Makefile         | 2 --
>  drivers/nfc/nxp-nci/Makefile | 2 --
>  2 files changed, 4 deletions(-)
Applied, with a massaged commit message.

Cheers,
Samuel.

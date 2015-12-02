Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36664 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbbLBP52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 10:57:28 -0500
Received: by iofh3 with SMTP id h3so50079913iof.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2015 07:57:27 -0800 (PST)
Date: Wed, 2 Dec 2015 09:57:26 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Update regulatory rules for Finland (FI)
Message-ID: <20151202155726.GA22529@ubuntu-xps13> (sfid-20151202_165732_094174_DB0D9084)
References: <1448479288-27002-1-git-send-email-anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448479288-27002-1-git-send-email-anssi.hannula@iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2015 at 09:21:28PM +0200, Anssi Hannula wrote:
> Bands in 5150-5350 MHz are limited to indoor use, and band 5150-5250 MHz
> has an increased power limit. The ranges are also slightly expanded to
> match the regulation.
> 
> Regulatory source (6 Feb 2015), Section 13:
> https://www.viestintavirasto.fi/attachments/maaraykset/Viestintavirasto15AH2015_en.pdf
> 
> Verified also from the authoritative Finnish version:
> https://www.viestintavirasto.fi/attachments/maaraykset/Viestintavirasto15AH2015M.pdf
> 
> Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>

Applied, thanks.

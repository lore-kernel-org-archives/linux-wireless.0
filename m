Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934374Ab2JXHUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 03:20:40 -0400
Message-ID: <1351063274.10709.1.camel@jlt4.sipsolutions.net> (sfid-20121024_092044_725732_0F66D458)
Subject: Re: [PATCH] mac80211: expose AES-CMAC subkey calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Assaf Krauss <assaf.krauss@intel.com>
Date: Wed, 24 Oct 2012 09:21:14 +0200
In-Reply-To: <1350994678-14752-1-git-send-email-johannes@sipsolutions.net> (sfid-20121023_141731_452545_766734B7)
References: <1350994678-14752-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121023_141731_452545_766734B7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-23 at 14:17 +0200, Johannes Berg wrote:
> From: Assaf Krauss <assaf.krauss@intel.com>
> 
> Expose a function for the AES-CMAC subkey calculation
> to drivers. This is the first step of the AES-CMAC
> cipher key setup and may be required for CMAC hardware
> offloading.

Applied.

johannes


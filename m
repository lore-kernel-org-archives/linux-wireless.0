Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934632Ab3BNPk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 10:40:27 -0500
Message-ID: <1360856422.8210.2.camel@jlt4.sipsolutions.net> (sfid-20130214_164031_096314_461E2058)
Subject: Re: [RFC] iw: support split wiphy dump
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: dennis.h.jensen@siemens.com
Date: Thu, 14 Feb 2013 16:40:22 +0100
In-Reply-To: <1360856049-2546-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_163418_636491_ECBFFDA6)
References: <1360855759-2377-1-git-send-email-johannes@sipsolutions.net>
	 <1360856049-2546-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130214_163418_636491_ECBFFDA6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 16:34 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This adds support for the new split wiphy dump,
> it only uses it for "iw list", not for "info"
> though, so far. Using it for "info" would mean
> querying the kernel capability first and then
> using get/dump (with filter) depending on that.

Dennis, are you up for implementing this in wpa_supplicant?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LPOKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:10:32 -0500
Message-ID: <1387203028.2057.4.camel@jlt4.sipsolutions.net> (sfid-20131216_151041_120939_A3095C14)
Subject: Re: [PATCH v2] mac80211: check pairwise key_idx on get_key call
From: Johannes Berg <johannes@sipsolutions.net>
To: Max.Stepanov@intel.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 15:10:28 +0100
In-Reply-To: <1386502252-10185-1-git-send-email-Max.Stepanov@intel.com> (sfid-20131208_123103_375945_8FA4F880)
References: <1386502252-10185-1-git-send-email-Max.Stepanov@intel.com>
	 (sfid-20131208_123103_375945_8FA4F880)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-12-08 at 13:30 +0200, Max.Stepanov@intel.com wrote:
> From: Max Stepanov <Max.Stepanov@intel.com>
> 
> Verify that a pairwise key index value on ieee80211_get_key call
> doesn't exceed the boundaries of the pairwise key array.

Applied.

johannes


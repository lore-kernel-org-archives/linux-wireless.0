Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36963 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161367AbXBOV1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 16:27:18 -0500
Date: Thu, 15 Feb 2007 22:27:16 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: fix authentication issues
Message-ID: <20070215222716.5001a833@griffin.suse.cz>
In-Reply-To: <200702081448.19664.flamingice@sourmilk.net>
References: <200702081448.19664.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Feb 2007 14:48:15 -0500, Michael Wu wrote:
> This patch prevents the MLME in d80211 from getting stuck when there is no
> reply to authentication frames. It also allows the bssid to be correctly
> set during IEEE80211_AUTHENTICATE.

Applied to my tree, thanks for the patch!

 Jiri

-- 
Jiri Benc
SUSE Labs

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:56418 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933204AbXFHApI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 20:45:08 -0400
Message-ID: <4668A692.50807@lwfinger.net>
Date: Thu, 07 Jun 2007 19:45:06 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
References: <4668a636.Z3Fxot6I8blAD4Hr%Larry.Finger@lwfinger.net>
In-Reply-To: <4668a636.Z3Fxot6I8blAD4Hr%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> The initial rate for STA's using rc80211_simple is set to the last
> rate in the rate table. For situations for which the signal is weak,
> the rate may be too high for authentication and association. Although
> the rc80211_simple module will adjust the speed, the response may not
> be fast enough for a successful connection. This modification sets the
> initial rate to the lowest supported value.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---

Sorry, I attached the wrong patch. Please ignore.

Larry

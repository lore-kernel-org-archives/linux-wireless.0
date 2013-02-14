Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab3BNRdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:33:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U62gq-0001ND-GA
	for linux-wireless@vger.kernel.org; Thu, 14 Feb 2013 18:33:44 +0100
Message-ID: <1360863221.8210.8.camel@jlt4.sipsolutions.net> (sfid-20130214_183348_010174_545EB4A2)
Subject: Re: [PATCH] mac80211: constify IE parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 18:33:41 +0100
In-Reply-To: <1360683974-14634-1-git-send-email-johannes@sipsolutions.net> (sfid-20130212_164627_409696_0E554CAA)
References: <1360683974-14634-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130212_164627_409696_0E554CAA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 16:46 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Make all the parsed IE pointers const, and propagate
> the change to all the users etc.

Applied.

johannes


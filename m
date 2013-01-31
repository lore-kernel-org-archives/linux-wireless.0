Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3AaNE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:04:59 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U0tp4-0000GR-Ns
	for linux-wireless@vger.kernel.org; Thu, 31 Jan 2013 14:04:58 +0100
Message-ID: <1359637523.8415.8.camel@jlt4.sipsolutions.net> (sfid-20130131_140503_833067_0E026070)
Subject: Re: [PATCH 1/2] mac80211: remove assoc data "sent_assoc"
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 31 Jan 2013 14:05:23 +0100
In-Reply-To: <1359453359-20767-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_105542_708903_6DD77997)
References: <1359453359-20767-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130129_105542_708903_6DD77997)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 10:55 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The field is never used, so remove it.

Applied both this and patch 2.

johannes


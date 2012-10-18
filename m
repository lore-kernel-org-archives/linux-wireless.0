Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2JRIwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 04:52:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TOlqK-0001ep-66
	for linux-wireless@vger.kernel.org; Thu, 18 Oct 2012 10:52:40 +0200
Message-ID: <1350550395.10638.1.camel@jlt4.sipsolutions.net> (sfid-20121018_105245_044837_117FA1B4)
Subject: Re: [PATCH 0/3] cfg80211 tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 18 Oct 2012 10:53:15 +0200
In-Reply-To: <1350325050-6994-1-git-send-email-johannes@sipsolutions.net> (sfid-20121015_201700_557568_E6F77C87)
References: <1350325050-6994-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121015_201700_557568_E6F77C87)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-15 at 20:17 +0200, Johannes Berg wrote:
> Hi,
> 
> Since mac80211 and iwlwifi tracing was so succesful
> (by being very helpful) we added tracing to cfg80211
> as well. This might help debug issues with the APIs
> or how they are used.

Applied.

johannes


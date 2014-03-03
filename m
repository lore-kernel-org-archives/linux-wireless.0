Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaCCNCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:02:21 -0500
Message-ID: <1393851737.10039.2.camel@jlt4.sipsolutions.net> (sfid-20140303_140224_210192_53005624)
Subject: Re: [PATCH] mac80211: refactor channel switch function
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Mar 2014 14:02:17 +0100
In-Reply-To: <1393599546-28023-1-git-send-email-michal.kazior@tieto.com> (sfid-20140228_160418_389873_AA422D96)
References: <1393599546-28023-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140228_160418_389873_AA422D96)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-28 at 15:59 +0100, Michal Kazior wrote:
> The function was quite big. This splits out beacon
> updating into a separate function for improved
> maintenance and extension.

Applied.

johannes


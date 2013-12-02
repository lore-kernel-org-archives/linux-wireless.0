Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3LBPCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 10:02:38 -0500
Message-ID: <1385996554.20277.5.camel@jlt4.sipsolutions.net> (sfid-20131202_160242_166379_978D2635)
Subject: Re: [PATCH v2] cfg80211: fix dfs channel state after stopping AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Dec 2013 16:02:34 +0100
In-Reply-To: <1384767413-5648-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20131118_103707_203761_B8998029)
References: <1384767413-5648-1-git-send-email-marek.puzyniak@tieto.com>
	 (sfid-20131118_103707_203761_B8998029)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-18 at 10:36 +0100, Marek Puzyniak wrote:
> This can be called when a mode of operation that can supports
> initiating radiation on a DFS channel leaves that channel to
> ensure that if the mode of operation is started again on it
> that it will require a new channel availability check.

Ugh, I don't understand - care to rephrase? Is this needed in 3.13?

johannes


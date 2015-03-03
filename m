Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54549 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbbCCI1v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 03:27:51 -0500
Message-ID: <1425371269.2450.4.camel@sipsolutions.net> (sfid-20150303_092754_603650_BA3D31C7)
Subject: Re: [PATCH] mac80211: drop unencrypted frames in mesh fwding
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 Mar 2015 09:27:49 +0100
In-Reply-To: <1425324532-11849-1-git-send-email-me@bobcopeland.com> (sfid-20150302_203017_444213_1358E266)
References: <1425324532-11849-1-git-send-email-me@bobcopeland.com>
	 (sfid-20150302_203017_444213_1358E266)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-02 at 14:28 -0500, Bob Copeland wrote:
> The mesh forwarding path was not checking that data
> frames were protected when running an encrypted network;
> add the necessary check.

Applied, thanks Bob.

johannes


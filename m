Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3EMJop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 05:44:45 -0400
Message-ID: <1368438281.8300.12.camel@jlt4.sipsolutions.net> (sfid-20130513_114552_230626_52CEB9F4)
Subject: Re: [PATCH v3 1/2] cfg80211: Userspace may inform kernel of mesh
 auth method.
From: Johannes Berg <johannes@sipsolutions.net>
To: Colleen Twitty <colleen@cozybit.com>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wirelss <linux-wireless@vger.kernel.org>
Date: Mon, 13 May 2013 11:44:41 +0200
In-Reply-To: <1368038760-17752-1-git-send-email-colleen@cozybit.com> (sfid-20130508_204609_420695_1F27EE7D)
References: <1368038760-17752-1-git-send-email-colleen@cozybit.com>
	 (sfid-20130508_204609_420695_1F27EE7D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-08 at 11:45 -0700, Colleen Twitty wrote:
> Authentication takes place in userspace, but the beacon is
> generated in the kernel.  Allow userspace to inform the
> kernel of the authentication method so the appropriate
> mesh config IE can be set prior to beacon generation when
> joining the MBSS.

Applied, thanks.

johannes


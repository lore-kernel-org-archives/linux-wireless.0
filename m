Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab2JVNeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 09:34:50 -0400
Message-ID: <1350912922.10166.12.camel@jlt4.sipsolutions.net> (sfid-20121022_153453_337594_7C8D46E1)
Subject: Re: [PATCH 1/2] iw: remove unnecessary variable in find_mesh_param
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Mon, 22 Oct 2012 15:35:22 +0200
In-Reply-To: <1349814567-29556-1-git-send-email-ashok@cozybit.com> (sfid-20121009_222939_309189_E3BDD922)
References: <1349814567-29556-1-git-send-email-ashok@cozybit.com>
	 (sfid-20121009_222939_309189_E3BDD922)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-09 at 13:29 -0700, Ashok Nagarajan wrote:
> Also stick to coding style. use "strcmp ( , ) == 0" instead of (!strcmp( , ))

Applied, I'll take the 2nd patch after the u64 changes

johannes


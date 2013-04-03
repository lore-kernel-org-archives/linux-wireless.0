Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35345 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761504Ab3DCMVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:21:38 -0400
Message-ID: <1364991693.8351.23.camel@jlt4.sipsolutions.net> (sfid-20130403_142145_705886_006BE590)
Subject: Re: [PATCH] mac80211: return new mpath from mesh_path_add()
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: thomas@cozybit.com, linux-wireless@vger.kernel.org
Date: Wed, 03 Apr 2013 14:21:33 +0200
In-Reply-To: <20130329133839.GB25331@localhost> (sfid-20130329_143900_595905_ECA036F2)
References: <20130329133839.GB25331@localhost>
	 (sfid-20130329_143900_595905_ECA036F2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-29 at 09:38 -0400, Bob Copeland wrote:
> Most times that mesh_path_add() is called, it is followed by
> a lookup to get the just-added mpath.  We can instead just
> return the new mpath in the case that we allocated one (or the
> existing one if already there), so do that.  Also, reorder the
> code in mesh_path_add a bit so that we don't need to allocate
> in the pre-existing case.

Applied.

johannes


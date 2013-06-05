Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52635 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3FEJrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 05:47:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Antonio Quartulli <ordex@autistici.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH 1/2] nl80211: allow sending CMD_FRAME without specifying any frequency
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
Date: Wed, 5 Jun 2013 12:47:01 +0300
In-Reply-To: <1370241587-2609-1-git-send-email-ordex@autistici.org> (Antonio
	Quartulli's message of "Mon, 3 Jun 2013 08:39:46 +0200")
Message-ID: <877gi8khyi.fsf@kamboji.qca.qualcomm.com> (sfid-20130605_114714_485827_469A4DF2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <ordex@autistici.org> writes:

> From: Antonio Quartulli <antonio@open-mesh.com>
>
> Users may want to send a frame on the current channel
> without specifying it.
>
> Make mgmt_tx pass a NULL channel to mac80211 if none has
> been specified by the user.
>
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>

Why? And what users are we talking about here? It would be nice if the
commit log would give some context here for use who nothing about this
patch. "Users may want" is not very informative :)

-- 
Kalle Valo

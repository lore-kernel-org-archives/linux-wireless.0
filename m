Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:32772 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbcBDDcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 22:32:54 -0500
Received: by mail-qg0-f67.google.com with SMTP id o11so2003576qge.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2016 19:32:54 -0800 (PST)
Date: Wed, 3 Feb 2016 22:32:51 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH v3 0/3] mac80211: add cleanup path for MPP table entries
Message-ID: <20160204033250.GA15719@localhost> (sfid-20160204_043257_673526_5EBC5F15)
References: <1454504318-24988-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454504318-24988-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 03, 2016 at 01:58:35PM +0100, Henning Rogge wrote:
> Henning Rogge (3):
>   mac80211: Remove MPP table entries with MPath
>   mac80211: let unused MPP table entries timeout
>   mac80211: Unify mesh and mpp path removal function
> 
>  net/mac80211/mesh_pathtbl.c | 102 +++++++++++++++++++++++++++++++++++++++-----
>  net/mac80211/rx.c           |   1 +
>  net/mac80211/tx.c           |   5 ++-
>  3 files changed, 97 insertions(+), 11 deletions(-)

Thanks for the revisions.  For what it's worth, series:

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% http://bobcopeland.com/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:36794 "EHLO
	mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbcGTLoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 07:44:22 -0400
Received: by mail-qt0-f174.google.com with SMTP id 52so24560036qtq.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2016 04:44:22 -0700 (PDT)
Date: Wed, 20 Jul 2016 07:44:18 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH] mac80211: End the MPSP even if EOSP frame was not
 received
Message-ID: <20160720114418.GE11996@localhost> (sfid-20160720_134442_145934_6D69CED3)
References: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
 <20160713135021.GE7819@localhost>
 <3ad771da-f4db-e29d-7b44-7e8a0865e3da@gmail.com>
 <20160719104034.GB11996@localhost>
 <1a324d4c-9a6b-1c0d-c18d-2df207de708c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1a324d4c-9a6b-1c0d-c18d-2df207de708c@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 20, 2016 at 04:11:33PM +0900, Masashi Honma wrote:
> On 2016年07月19日 19:40, Bob Copeland wrote:
> >
> >OK, do we need to also clear WLAN_STA_PS_STA flag for the peer in
> >ieee80211_mps_sta_status_update(), or does the node completely repeer?
> >
> >ISTR running into a problem where rebooted peer (previously in power-save)
> >would send popen but we would buffer the response due to stale PS sta
> >flag.
[...]
>
> So looks no problem.

Ok, thanks for testing that - fwiw original patch

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% http://bobcopeland.com/

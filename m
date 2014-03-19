Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:39195 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933380AbaCSODe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:03:34 -0400
Message-ID: <1395237785.2854.13.camel@dubbel> (sfid-20140319_150336_783440_D2890616)
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Date: Wed, 19 Mar 2014 16:03:05 +0200
In-Reply-To: <1395154986-13810-1-git-send-email-luciano.coelho@intel.com>
References: <1395154986-13810-1-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v10 0/4] mac802111: channel context reservation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-18 at 17:03 +0200, Luciano Coelho wrote:
> One more small fix to a WARN_ON detected by Michal.  One change in
> patch 3/4 (which also goes into 4/4).
> 
> --
> Luca.
> 
> Luciano Coelho (4):
>   mac80211: split ieee80211_vif_change_channel in two
>   mac80211: refactor ieee80211_assign/unassign_vif_chanctx into one
>   mac80211: implement chanctx reservation
>   mac80211: allow reservation of a running chanctx


Applied this series to my mac80211-next-csa.git tree.

--
Luca.


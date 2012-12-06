Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab2LFIvz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 03:51:55 -0500
Date: Thu, 6 Dec 2012 09:51:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Chaitanya <chaitanyatk@posedge.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix the multiple warnings for budding chipsets
 without ampdu_action defined
Message-ID: <20121206085146.GC2502@redhat.com> (sfid-20121206_095158_574403_8747EEE7)
References: <50C0545B.8060805@posedge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50C0545B.8060805@posedge.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 06, 2012 at 01:46:27PM +0530, Chaitanya wrote:
> Changed the mail client to thunder bird to avoid whitespace issues.
> Changed the subject and also the signing off to use offical mail.
> Changed the setting for tabs (width=8, noexpandtab) and whitespaces.

Don't need to mess up the change log with that.

> Signed-off-by: T Krishna Chaitanya <chaitanyatk@posedge.com>
> ---
> net/mac80211/agg-tx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 4152ed1..eb9df22 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -445,7 +445,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>  
>      trace_api_start_tx_ba_session(pubsta, tid);
>  
> -    if (WARN_ON(!local->ops->ampdu_action))
^^^^^^^
Patch is still malformed (spaces instead of one tab). Before next
posting to mailing list, post patch to yourself and try to apply
it. Once that success, continue with mailing list posting.

Thanks
Stanislaw  

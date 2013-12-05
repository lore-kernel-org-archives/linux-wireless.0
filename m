Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3LEQFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 11:05:48 -0500
Message-ID: <1386259544.4182.14.camel@jlt4.sipsolutions.net> (sfid-20131205_170550_326574_D1E9AB3E)
Subject: Re: [PATCH v8 3/5] mac80211: refactor
 ieee80211_mesh_process_chanswitch()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com, yeohchunyeow@cozybit.com,
	andrei.otcheretianski@intel.com
Date: Thu, 05 Dec 2013 17:05:44 +0100
In-Reply-To: <1386257143-29840-4-git-send-email-luciano.coelho@intel.com> (sfid-20131205_162558_512881_D06BF6C3)
References: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com>
	 <1386257143-29840-4-git-send-email-luciano.coelho@intel.com>
	 (sfid-20131205_162558_512881_D06BF6C3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 17:25 +0200, Luciano Coelho wrote:

> +++ b/net/mac80211/util.c
> @@ -2498,7 +2498,6 @@ int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
>  			ifmsh->pre_value++;
>  		put_unaligned_le16(ifmsh->pre_value, pos);/* Precedence Value */
>  		pos += 2;
> -		ifmsh->chsw_init = true;

Where did this go? I'm asking mostly because mac80211.git has a patch
that changed this code so I'm wondering how to resolve the conflict ...

johannes


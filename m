Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48344 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298AbZKXWzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 17:55:00 -0500
Subject: Re: [RFC 1/3] nl80211: PMKSA caching support
From: Marcel Holtmann <marcel@holtmann.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
References: <cover.1259075573.git.sameo@linux.intel.com>
	 <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 23:54:57 +0100
Message-ID: <1259103297.2967.40.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

>  /* policy for the attributes */
> @@ -561,6 +563,9 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
>  	CMD(deauth, DEAUTHENTICATE);
>  	CMD(disassoc, DISASSOCIATE);
>  	CMD(join_ibss, JOIN_IBSS);
> +	CMD(set_pmksa, SET_PMKSA);
> +	CMD(del_pmksa, DEL_PMKSA);
> +	CMD(flush_pmksa, FLUSH_PMKSA);

once these have been accepted, don't forget to send a patch for iw that
actually prints out the supported command list.

Regards

Marcel



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaDHNXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 09:23:21 -0400
Message-ID: <1396963387.11971.0.camel@jlt4.sipsolutions.net> (sfid-20140408_152324_413069_CA9CDD1B)
Subject: Re: [PATCH v3 02/13] mac80211: add max channel calculation utility
 function
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Apr 2014 15:23:07 +0200
In-Reply-To: <1396262371-6466-3-git-send-email-michal.kazior@tieto.com> (sfid-20140331_134306_188335_9872A03A)
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	 <1396262371-6466-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140331_134306_188335_9872A03A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-31 at 12:39 +0200, Michal Kazior wrote:

> +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +		num[sdata->wdev.iftype]++;
> +	}

Don't really need the braces, I guess.

johannes


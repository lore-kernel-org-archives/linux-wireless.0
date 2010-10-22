Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50173 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0JVNPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 09:15:07 -0400
Received: by iwn34 with SMTP id 34so920759iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 06:15:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287752787-6616-1-git-send-email-rmanoharan@atheros.com>
References: <1287752787-6616-1-git-send-email-rmanoharan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Oct 2010 06:14:44 -0700
Message-ID: <AANLkTi=DwO_2t_p_+aeh6bBow_NR5=xoPw4A5L8X91ye@mail.gmail.com>
Subject: Re: [RFC] mac80211: Fix ibss station got expired immediately
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 22, 2010 at 6:06 AM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> Station addition in ieee80211_ibss_rx_queued_mgmt is not updating
> sta->last_rx which is causing station expiry in ieee80211_ibss_work
> path. So sta addition and deletion happens repeatedly.
>
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

stable fix?

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60848 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab3EISbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 14:31:39 -0400
Message-ID: <518BEB88.5090600@openwrt.org> (sfid-20130509_203154_523606_2A0F0AA8)
Date: Thu, 09 May 2013 20:31:36 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 2/8] mac80211: fix various components for the new 5 and
 10 MHz widths
References: <1368123036-22721-1-git-send-email-a> <1368123036-22721-3-git-send-email-a>
In-Reply-To: <1368123036-22721-3-git-send-email-a>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-09 8:10 PM, a@pandem0nium wrote:
> From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> 
> This is a collection of minor fixes:
>  * don't allow HT IEs in IBSS for 5/10 MHz
>  * don't allow HT IEs in Mesh for 5/10 MHz
>  * consider 5 and 10 MHz channels when downgrading
>  * don't try HT rates for 5 and 10 MHz channels when selecting rates
Why? HT rates work with 5/10 MHz just fine.

- Felix


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:30602 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbYJGR6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 13:58:00 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2890052fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 10:57:59 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 and IEEE80211_CONF_SHORT_SLOT_TIME
Date: Tue, 7 Oct 2008 19:57:54 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chr <chunkeey@web.de>, Pavel Roskin <proski@gnu.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
References: <1223370325.3778.69.camel@johannes.berg>
In-Reply-To: <1223370325.3778.69.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810071957.55250.IvDoorn@gmail.com> (sfid-20081007_195804_925919_2DF83262)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I just realised that for whatever reason mac80211 isn't setting the
> IEEE80211_CONF_SHORT_SLOT_TIME flag. I'm not sure when or why that was
> removed, but clearly it isn't used.
> 
> Can you please fix the drivers using it (b43, b43legacy, iwlwifi, p54,
> rt2x00, rtl8180, rtl8187) to use the bss_conf's use_short_slot instead?
> I'll fix mac80211 to set that appropriately.

Didn't you have such a patch for rt2x00 already?
If not I'll see what I can do in a few days.

Ivo



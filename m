Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55362 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab0A1OA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 09:00:27 -0500
Received: by ewy19 with SMTP id 19so775341ewy.21
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2010 06:00:26 -0800 (PST)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Joerg Pommnitz <pommnitz@yahoo.com>,
	linux-wireless@vger.kernel.org,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: Re: mac80211: Open bug in current wireless-testing
References: <868377.1443.qm@web51406.mail.re2.yahoo.com>
	<43e72e891001271012r60356d85k60fe55fbb027aa40@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 28 Jan 2010 16:00:22 +0200
In-Reply-To: <43e72e891001271012r60356d85k60fe55fbb027aa40@mail.gmail.com> (Luis R. Rodriguez's message of "Wed\, 27 Jan 2010 10\:12\:21 -0800")
Message-ID: <87eilal47d.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

> iwconfig wlan0 power off # disables power save

I'm going to add this to nl80211 "real soon now", latest next week.

> iwconfig wlan0 power 500m # enables dynamic power wave with 500ms idle
> timeout trigger

I have thinking and I think the timeout should be in debugfs, not in
nl80211. It's mostly for debugging anyway, I can't see how, for
example, wpa_supplicant would be able to use this. But I'll send a
separate email later about this.

-- 
Kalle Valo

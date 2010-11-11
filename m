Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33587 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab0KKG6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 01:58:39 -0500
Received: by ewy7 with SMTP id 7so923217ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 22:58:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101109212422.GE2374@tuxdriver.com>
References: <AANLkTi=t-rEsFKMv-V7Q3cyY6A_+LiBBYW2WbwXzg50b@mail.gmail.com>
	<20101109212422.GE2374@tuxdriver.com>
Date: Wed, 10 Nov 2010 22:58:37 -0800
Message-ID: <AANLkTi=jZFzwO-uzgyYCrJNrS_M2aNvZ1YuUOnBXz0Ge@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: Incorporate txpower into rssi
From: Blaise Gassend <blaise@willowgarage.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linville@redhat.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This patch seems to be whitespace-damaged.  Also, you should have a
> space around the "-" operator.

Do you need me to recreate the patch?

> Any comments on this patch from the mac80211_hwsim users?

To reply to Jouni's comments, I agree that a more complete model of
RSSI would be nice, but I think that whatever more complete model
emerges will have txpower as an additive term when determining rssi.
So this is a step in the right direction. I'm using this to test an
RSSI-based roaming code, so this little addition serves my purposes
great for now.

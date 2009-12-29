Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55533 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZL2A7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 19:59:07 -0500
Received: by bwz27 with SMTP id 27so6776290bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 28 Dec 2009 16:59:04 -0800 (PST)
From: Holger Schurig <holgerschurig@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH v3 2/5] mac80211: fix propagation of failed hardware reconfigurations
Date: Tue, 29 Dec 2009 02:58:15 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
References: <1261687102-19563-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1261687102-19563-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200912290258.15541.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +			WARN(local->suspended, "Harware became unavailable "

Typo: it's "Hardware", not "Harware". Hmm, sometimes it's hairware :-)


-- 
http://www.holgerschurig.de

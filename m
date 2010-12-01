Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41300 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0LACTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 21:19:03 -0500
Received: by gxk1 with SMTP id 1so184110gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 18:19:03 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: ath5k: Fixes for mesh operation
Date: Tue, 30 Nov 2010 18:18:36 -0800
Message-Id: <1291169919-3867-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After applying these fixes we were able to successfully bring up mesh
interfaces and establish peer links with ath9k devices.  

One issue still looms with both athX drivers:  you have to issue a scan to get
mesh beaconing started.  Keep that in mind if you try and test these fixes.


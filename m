Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:57264 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175AbZHHDtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 23:49:47 -0400
Received: by pzk34 with SMTP id 34so1943403pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 20:49:48 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: andrey@cozybit.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
Subject: Mesh fixes and improvements
Date: Fri,  7 Aug 2009 20:38:23 -0700
Message-Id: <1249702711-32737-1-git-send-email-javier@cozybit.com>
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Resent with proper patch numbering...]

This series includes some fixes, testing aids and improvements to the mesh
stack.  It is important to note that the patch
"Use-3-address-format-for-mesh-broadcast-frames" breaks compatibility with
previous versions.  This is unavoidable and will keep happening as new versions
of the 802.11s drafts are produced.

Also, I'm not sure if "Simulate-transmission-losses-on-plinks-to-..." should be
merged upstream, but we find it really useful to test mesh configurations.
Please comment if you have different opinions on its adequacy or
implementation.

Cheers,


Javier

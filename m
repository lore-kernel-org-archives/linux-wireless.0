Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:61183 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZLSI75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 03:59:57 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 19 Dec 2009 00:59:36 -0800
Message-ID: <43e72e890912190059k3347887crfb7ded226c7a8d4b@mail.gmail.com>
Subject: Compat-wireless releases for 2.6.33-rc1 and 2.6.32.2
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.6.33-rc1 went out yesterday so today we get the respective backport
code now with 802.11 and bluetooth combined on the compat-wireless
package [1]. At this point only bug fixes are welcomed for that
package. At the last minute I decided to add Atheros Ethernet drivers
atlx, atl1e and atl1c. For wireless specific updates refer to wireless
2.6.33-rc1 ChangeLog [2]. If there are any bugs please report them
through linux-wireless. I've tested ath5k on 2.6.27.41 on x86_64 and
send this e-mail out through it. I should note
./scripts/drivers-select is busted as I never got a chance to update
it based on the latest changes.

While at it 2.6.32.2 got released today so I just updated a release
for that so users can benefit from the few fixes [3], you can check
the ChangeLog for that on the wireless for details on the changes [4].

For more details and sha1 checksums you can refer to the wireless wiki
compat-wireless stable page [5].

[1] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/compat-wireless-2.6.33-rc1.tar.bz2
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/ChangeLog-2.6.33-rc1-wireless
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32.2.tar.bz2
[4] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/ChangeLog-2.6.32.2-wireless
[5] http://wireless.kernel.org/en/users/Download/stable

  Luis

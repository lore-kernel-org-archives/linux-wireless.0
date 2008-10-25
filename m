Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYJYIYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 04:24:18 -0400
Subject: build warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Chr <chunkeey@web.de>, Tomas Winkler <tomasw@gmail.com>,
	mcgrof <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 25 Oct 2008 10:24:10 +0200
Message-Id: <1224923050.27353.1.camel@johannes.berg> (sfid-20081025_102423_133893_CBC33AEC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

just FYI in case you haven't seen them. the p54 one looks like a genuin=
e
problem.

drivers/net/wireless/iwlwifi/iwl-scan.c:69: warning: =E2=80=98scan_tx_a=
nt=E2=80=99 defined but not used
drivers/net/wireless/ath9k/hw.c: In function =E2=80=98ath9k_hw_eeprom_s=
et_board_values=E2=80=99:
drivers/net/wireless/ath9k/hw.c:544: warning: =E2=80=98ant_config=E2=80=
=99 may be used uninitialized in this function
drivers/net/wireless/p54/p54common.c: In function =E2=80=98p54_parse_ee=
prom=E2=80=99:
drivers/net/wireless/p54/p54common.c:325: warning: =E2=80=98synth=E2=80=
=99 may be used uninitialized in this function


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

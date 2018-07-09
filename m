Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta24.messagelabs.com ([67.219.250.208]:30960 "EHLO
        mail1.bemta24.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751132AbeGIF65 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 01:58:57 -0400
From: "Palanisamy, Rameshbabu" <Rameshbabu.Palanisamy@harman.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: iwlwifi is not working after doing the reboot by pressing RESET
 button
Date: Mon, 9 Jul 2018 05:57:51 +0000
Message-ID: <2f72033224fa47dcad87a69e8bd6a1e1@HIBDWSMB05.ad.harman.com> (sfid-20180709_075901_725387_56D34D75)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Team,


I am using intel 8265 NGW wifi card in intel leafhill board.

We have enabled the Intel -wifi card in the Leaf_hill platform. After powering on the device, the wifi module is working fine but it doesn't work when we do the reboot by pressing RESET button.
We have debug the issue and found that  when we do the hard reboot by pressing the RESET key, the wifi module doesn't detected.
We have given the  lspci command before and after the hard reboot and the module is not listing in the lspci after hard reboot so we are suspecting that wifi module is not in the proper state due to the hard reboot.
Could you please help to know what might be the issue.


Thanks,
Ramesh

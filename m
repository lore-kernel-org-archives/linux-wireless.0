Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27024 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3AIRUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 12:20:24 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: Q: how to update platform power state for the network driver
Date: Wed, 9 Jan 2013 19:20:06 +0200
Message-ID: <6929081.7c7blFVDp4@lx-vladimir> (sfid-20130109_182029_783210_FC7FE104)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

in 60g spec (802.11ad, references to this doc.), station should set "power source" bit in the:

8.4.2.130.3 DMG PCP/AP Capability Information field

This information used to construct "PCP factor" that used in:

10.1.4.3.4 PCP selection in a PBSS

This procedure replaces GO negotiation in P2P. "power source" bit above specified as:

The Power Source field is set to 0 if the STA is battery powered, and is set to 1 otherwise.

What is the best way to obtain this info in the network driver?

Thanks, Vladimir.

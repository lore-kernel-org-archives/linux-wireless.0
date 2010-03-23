Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from thoth.sbs.de ([192.35.17.2]:22747 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab0CWQ3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 12:29:48 -0400
Received: from mail3.siemens.de (localhost [127.0.0.1])
	by thoth.sbs.de (8.12.11.20060308/8.12.11) with ESMTP id o2NGTkB0016463
	for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 17:29:46 +0100
Received: from DEMCHP99ET2MSX.ww902.siemens.net ([139.25.131.241])
	by mail3.siemens.de (8.12.11.20060308/8.12.11) with ESMTP id o2NGTk45001221
	for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 17:29:46 +0100
From: "Porsch, Marco" <marco.porsch@siemens.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 23 Mar 2010 17:29:45 +0100
Subject: Mesh mode broken in compat-wireless?
Message-ID: <7F2FE3504A6CB54497542A539E401A7B9A0C4294@DEMCHP99E15MSX.ww902.siemens.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello list,

since compat-wireless-2010-03-03 (and the previous) mesh mode does not work for me anymore.
The problem is, that peering links do not establish between mesh points. The peering status changes between LISTEN, OPN_SNT and HOLDING, but does not reach ESTAB.
Using patched wireshark I can see lots of malformed packets in response to peer link management frames.
I upgraded all my nodes to the same version. But the problem is the same with just one node on the newer version.

I am using latest OpenWrt with ye olde compat-wireless-2010-03-03 (no new version included until now). Driver is ath9k, hardware is Netgear WNDR3700.

The mesh configuration should be fine, sine with compat-wireless-2010-02-02 everything was ok.

I could not try this with standard hardware, so at first it would be interesting, if this is a general problem or just OpenWrt specific.


Regards

Marco
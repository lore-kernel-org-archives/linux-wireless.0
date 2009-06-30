Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:2849 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355AbZF3VSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:18:45 -0400
Subject: [PATCH 0/5] Enhance CRDA's Makefile for cross building
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 16:18:49 -0500
Message-Id: <1246396729.13176.257.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch series enhances CRDA's Makefile to support both native
and cross built targets.


Jon Loeliger (5):
  Allow .config to supply optional local Makefile settings.
  Separate install target into exec, udev and man sub-parts.
  Have the 'clean' target announce its presence.
  Introduce separate HOST and TARGET compilation steps.
  Unbury Makefile-meta config definitions.

 Makefile |  281 +++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 223 insertions(+), 58 deletions(-)



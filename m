Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:36190 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZKNNTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 08:19:15 -0500
MIME-Version: 1.0
In-Reply-To: <1258082571.7715.13.camel@violet>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
	 <1258082571.7715.13.camel@violet>
Date: Sat, 14 Nov 2009 18:49:20 +0530
Message-ID: <4fb5db50911140519q70bbdd00qb585153c4926df96@mail.gmail.com>
Subject: Re: [patch 0/1] Adding radio type FM
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: majordomo@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resubmitting patch  adding Marcels Comments

>From f72e4bdef7c423259f2f8f0615d024a25294ea8f Mon Sep 17 00:00:00 2001
From: Janakiram Sistla <janakiram.sistla@gmail.com>
Date: Sat, 14 Nov 2009 18:42:35 +0530
Subject: [PATCH 1/1] Adding radio type FM

Adding radio type FM in RFKILL_TYPE_.FM also belongs to
same class of with both TX/RX capability.

Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
---
 include/linux/rfkill.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 3392c59..03f5598 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -45,6 +45,7 @@ enum rfkill_type {
 	RFKILL_TYPE_WIMAX,
 	RFKILL_TYPE_WWAN,
 	RFKILL_TYPE_GPS,
+	RFKILL_TYPE_FM,
 	NUM_RFKILL_TYPES,
 };

-- 
1.5.4.3

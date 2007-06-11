Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:33902 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758907AbXFKKjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 06:39:17 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id B56028D761
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2007 12:39:13 +0200 (CEST)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 5FEBC13C7A
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2007 10:39:37 +0000 (UTC)
Message-Id: <20070611103828.961999956@warmcat.com>
Date: Mon, 11 Jun 2007 11:38:28 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] Small driver fixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Couple of things don't work properly with radiotap rx yet.  These patches make them work.
-- 

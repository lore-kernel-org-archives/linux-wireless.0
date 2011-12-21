Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.bufferbloat.net ([149.20.54.82]:40135 "EHLO
	huchra.bufferbloat.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1LUIsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 03:48:42 -0500
From: Dave Taht <dave.taht@bufferbloat.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/1] Treat IPv6 diffserv the same as ipv4 diffserv for 802.11e
Date: Wed, 21 Dec 2011 00:41:44 -0800
Message-Id: <1324456905-2628-1-git-send-email-dave.taht@bufferbloat.net> (sfid-20111221_094846_036517_13233608)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This treats ipv6 and ipv4 the same, on wireles, where diffserv is
concerned.

I note that it would be nice if this mechanism tossed packets marked
with the interactive bit into the VI queue as well. Nicer still
would be a more generic and comprehensive diffserv handling.


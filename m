Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58352 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab0AHR1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:27:37 -0500
Date: Fri, 8 Jan 2010 18:27:35 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 00/11] more mwl8k updates for wireless-testing
Message-ID: <20100108172735.GT1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series: some minor cleanups and fixes, initial support for AP
interfaces (b/g only for now), and an implementation of NAPI-like
receive-side polling for increased performance and reduced CPU usage
at HT rates.

Feedback appreciated!

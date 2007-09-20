Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbXITEkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 00:40:15 -0400
Date: Wed, 19 Sep 2007 21:40:07 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: ath5k and network manager
Message-ID: <20070919214007.1a6a9b4a@freepuppy.rosehill>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Network manager doesn't seem to detect ath5k. Perhaps it is because
it is name "ath0".  I think device should follow the convention of using
name "wifi0" rather than BSD convention of putting driver name in device name.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

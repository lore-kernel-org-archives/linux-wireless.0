Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57039 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab0DGTAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 15:00:13 -0400
Date: Wed, 7 Apr 2010 14:55:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: reinette.chatre@intel.com
Subject: wireless-next-2.6 rebased from commit
	bc53e5129ce879ba024b7d21981871ea63a37b42
Message-ID: <20100407185509.GA3058@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I accidentally pushed some junk to wireless-next-2.6 yesterday.
It didn't get pulled into wireless-testing and it wasn't sent to Dave,
but just in case anyone pulled wireless-next-2.6 in the past day or
so you should be aware of a coming "forced" update.

Sorry for the inconvenience!

John

P.S.  I just removed a revert an the original patch it was reverting --
the diff should be zero.
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44242 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab1HaSAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 14:00:23 -0400
Date: Wed, 31 Aug 2011 13:45:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k_hw: Fix rx latency of 11a mode
Message-ID: <20110831174512.GC2474@tuxdriver.com> (sfid-20110831_200027_014284_961A62D2)
References: <1314767850-1112-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1314767850-1112-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 10:47:30AM +0530, Rajkumar Manoharan wrote:
> Rx latecy to start signal(usec) of 11a is 41 not 37 and
> also corrected the rx delay in quarter rate.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Do you still want 'ath9k_hw: Fix slottime with coverage class" merged
as well?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

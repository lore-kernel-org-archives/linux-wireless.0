Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58715 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0FOUAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 16:00:12 -0400
Date: Tue, 15 Jun 2010 15:51:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Modify LED blinking pattern during wifi activity.
Message-ID: <20100615195157.GC2415@tuxdriver.com>
References: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 10:50:17AM +0530, Vivek Natarajan wrote:
> Some vendors require the LED to be ON always irrespective of any
> radio activity. Introducing a module parameter to enable this,
> so that one can choose between always on or led blink during
> activity.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Any particular reason the always-on behaviour is the default?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

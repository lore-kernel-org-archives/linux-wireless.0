Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:51957 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab0JEMJf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 08:09:35 -0400
Received: from [172.21.50.167] (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o95C9XxI019377
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 15:09:33 +0300
Subject: Re: [PATCH] wl1271: remove deprecated __attribute__ ((packed))
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286280139-12378-1-git-send-email-luciano.coelho@nokia.com>
References: <1286280139-12378-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 15:09:20 +0300
Message-ID: <1286280560.15401.31.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 14:02 +0200, ext Luciano Coelho wrote:
> One __attribute__ ((packed)) has been accidentally introduced in commit
> be86cbea1e9c3a4dd8faedcfa327495d09fe3531.  This patch changes it to __packed.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---

Applied and pushed to wl12xx/master.


-- 
Cheers,
Luca.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:35902 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYLXNYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 08:24:36 -0500
Date: Wed, 24 Dec 2008 13:24:32 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 3/3] mac80211: implement dynamic power save
Message-ID: <20081224132432.GA27658@srcf.ucam.org> (sfid-20081224_142441_058558_FBB4BD5D)
References: <20081218211532.6842.88104.stgit@tikku> <20081218211712.6842.98402.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081218211712.6842.98402.stgit@tikku>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Are we able to estimate the worst-case latency that will be introduced 
by this? If so, it would be helpful to tie it into the pm_qos framework.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38604 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYL1NAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 08:00:00 -0500
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 3/3] mac80211: implement dynamic power save
References: <20081218211532.6842.88104.stgit@tikku>
	<20081218211712.6842.98402.stgit@tikku>
	<20081224132432.GA27658@srcf.ucam.org>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 28 Dec 2008 14:59:35 +0200
In-Reply-To: <20081224132432.GA27658@srcf.ucam.org> (ext Matthew Garrett's message of "Wed\, 24 Dec 2008 13\:24\:32 +0000")
Message-ID: <87wsdkmp54.fsf@nokia.com> (sfid-20081228_140003_499416_E1AC46C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> Are we able to estimate the worst-case latency that will be introduced 
> by this? If so, it would be helpful to tie it into the pm_qos framework.

I'm not familiar with pm_qos framework, unfortunately, but there's
some work to do still to get mac80211 client power save implemention
into shape and I would like get the basics implemented first. After
that is done, we could start looking at the pm_qos framework and see
if it makes sense to use it.

-- 
Kalle Valo

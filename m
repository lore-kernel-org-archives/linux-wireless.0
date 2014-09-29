Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54093 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaI2G2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 02:28:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21544.64579.558712.465388@gargle.gargle.HOWL> (sfid-20140929_082851_768176_28D09771)
Date: Mon, 29 Sep 2014 11:59:23 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath: Add support for tracing
In-Reply-To: <87vbo72bb7.fsf@kamboji.qca.qualcomm.com>
References: <1411804665-6954-1-git-send-email-sujith@msujith.org>
	<87vbo72bb7.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Why add it to ath.ko module? What drivers are going to use this?

The debug code for ath9k is in ath.ko.

Sujith

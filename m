Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42531
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbXB0Pmo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 10:42:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] bcm43xx-d80211: fix a sparse warning
Date: Tue, 27 Feb 2007 16:42:04 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1172531554.3870.208.camel@johannes.berg>
In-Reply-To: <1172531554.3870.208.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702271642.04870.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 February 2007 00:12, Johannes Berg wrote:
> This fixes a missing prototype sparse complains about.

Thanks, applied. 

-- 
Greetings Michael.

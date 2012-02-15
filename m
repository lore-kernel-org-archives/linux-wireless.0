Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60186 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2BOTQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 14:16:44 -0500
Date: Wed, 15 Feb 2012 14:01:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	magnus.maatta@logica.com
Subject: Re: [PATCH 3.3] ath9k_hw: prevent writes to const data on AR9160
Message-ID: <20120215190137.GH4379@tuxdriver.com> (sfid-20120215_201648_025105_4AC4A6D0)
References: <1329330680-62602-1-git-send-email-nbd@openwrt.org>
 <20120215183047.GD4379@tuxdriver.com>
 <4F3BFF2B.8080706@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F3BFF2B.8080706@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 15, 2012 at 07:53:31PM +0100, Felix Fietkau wrote:
> On 2012-02-15 7:30 PM, John W. Linville wrote:
> > Do you have a link to the reported crash?
> It was reported on IRC, the trace is here: http://pastebin.com/wvxXwLs4

Cool, thanks.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

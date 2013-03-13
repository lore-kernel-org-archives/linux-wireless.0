Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51881 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3CMSac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 14:30:32 -0400
Date: Wed, 13 Mar 2013 14:29:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 14/14] wil6210: temperature measurement
Message-ID: <20130313182901.GC19917@tuxdriver.com> (sfid-20130313_193048_243602_AB5ACB1F)
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1363176771-10082-15-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363176771-10082-15-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 13, 2013 at 02:12:51PM +0200, Vladimir Kondratiev wrote:
> Firmware got support for temperature measurement.
> There are 2 temperature sensors: MAC and radio
> 
> "not available" temperature - reported by FW as 0 or ~0
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
> Conflicts:
> 	drivers/net/wireless/ath/wil6210/wil6210.h

I edited-out the Conflicts bit -- not sure how/why that got into your
patch posting...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

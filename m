Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48680 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab0LGTaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 14:30:09 -0500
Date: Tue, 7 Dec 2010 14:28:06 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/3] iwlagn: implement layout-agnostic EEPROM reading
Message-ID: <20101207192806.GF2700@tuxdriver.com>
References: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
 <1291743428-19642-3-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291743428-19642-3-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 07, 2010 at 09:37:07AM -0800, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The current EEPROM reading code has some layout
> assumptions that now turned out to be false with
> some newer versions of the EEPROM. Luckily, we
> can avoid all such assumptions by using data in
> the EEPROM itself, so implement using that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Is rewriting the EEPROM code really necessary for 2.6.37?  This seems
like a lot of code to potentially get wrong...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

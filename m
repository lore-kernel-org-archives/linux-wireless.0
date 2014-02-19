Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaBSK5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 05:57:08 -0500
Message-ID: <1392807420.4733.11.camel@jlt4.sipsolutions.net> (sfid-20140219_115713_111685_18E23802)
Subject: Re: [PATCH] cfg80211: bugfix in regulatory user hint process
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Inbal Hacohen <Inbal.Hacohen@intel.com>
Date: Wed, 19 Feb 2014 11:57:00 +0100
In-Reply-To: <1392190347-5570-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1392190347-5570-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-12 at 09:32 +0200, Emmanuel Grumbach wrote:
> From: Inbal Hacohen <Inbal.Hacohen@intel.com>
> 
> After processing hint_user, we would want to schedule the
> timeout work only if we are actually waiting to CRDA. This happens
> when the status is not "IGNORE" nor "ALREADY_SET".

Applied.

johannes


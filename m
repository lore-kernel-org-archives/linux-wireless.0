Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaATKut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 05:50:49 -0500
Message-ID: <1390215046.4335.7.camel@jlt4.sipsolutions.net> (sfid-20140120_115051_663694_3B612795)
Subject: Re: [PATCH 1/5] cfg80211: don't check regulatory bandwidth
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Mon, 20 Jan 2014 11:50:46 +0100
In-Reply-To: <1389947524-6102-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_093216_067953_F7810868)
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389947524-6102-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140117_093216_067953_F7810868)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-17 at 09:32 +0100, Janusz Dziedzic wrote:
> Don't check regulatory bandwith base on
> single regulatory rule. There will be introduced
> new code that will calculate maximum bandwidth
> base on all contiguous rules.

I don't think you should break code like that in the middle.

johannes


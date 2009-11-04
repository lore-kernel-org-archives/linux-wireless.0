Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:62973 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbZKDSND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 13:13:03 -0500
Received: by fg-out-1718.google.com with SMTP id 16so404357fgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 10:13:07 -0800 (PST)
Message-ID: <4AF1C42E.7000808@lwfinger.net>
Date: Wed, 04 Nov 2009 12:13:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>, sidhayn@gmail.com,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
 LEDS enabled (Bugzilla #14539)
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <20091104151132.GD12965@tuxdriver.com> <4AF1A3BD.1020009@lwfinger.net> <20091104165453.GH12965@tuxdriver.com>
In-Reply-To: <20091104165453.GH12965@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2009 10:54 AM, John W. Linville wrote:
> On Wed, Nov 04, 2009 at 09:54:37AM -0600, Larry Finger wrote:
> 
>> I will try once more to get netconsole working to capture the backtrace.
> 
> No need, I think I understand it now.  The new order still sorta
> looks/feels "wrong", but it seems fine.  Maybe an alternative would
> be to make the brightness_set routine aware of the shutdown and not
> queue the work?  Maybe even ieee80211_queue_delayed_work could be
> made a bit smarter here?

Are either of these questions a request, or are they musings?

Larry

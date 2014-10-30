Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57984 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934564AbaJ3P1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 11:27:16 -0400
Message-ID: <545258D6.20000@lwfinger.net> (sfid-20141030_162720_336768_58F5552A)
Date: Thu, 30 Oct 2014 10:27:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: Re: [PATCH 0/6 3.18] Fixes for iwlwifi drivers
References: <1414642633-3700-1-git-send-email-Larry.Finger@lwfinger.net> <1414667312.27833.22.camel@coelho.fi>
In-Reply-To: <1414667312.27833.22.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2014 06:08 AM, Luca Coelho wrote:
> The cover-letter subject is wrong. :) I guess you meant
> s/iwlwifi/rtlwifi/ ;)

Yes, the changes were for rtlwifi, not iwlwifi. Sorry. (:

My laptop has an Intel 7260 card built in, and it is working correctly on both 
2.4 and 5G bands under mainline 3.18-rc2.

Those types of errors are what I get for trying to "work" while on a family 
vacation. Unfortunately, I needed to submit those patches quickly to prevent a 
set of conflicting updates from being accepted, and I made a silly mistake.

Larry


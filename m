Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0140.hostedemail.com ([216.40.44.140]:33289 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752650AbdDQQJ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2017 12:09:58 -0400
Message-ID: <1492445382.8661.9.camel@perches.com> (sfid-20170417_181002_263539_05A48246)
Subject: Re: [PATCH 12/13] rtlwifi: btcoex: 21a 1ant: fix some coding style
 issues
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Date: Mon, 17 Apr 2017 09:09:42 -0700
In-Reply-To: <20170417000700.29057-13-Larry.Finger@lwfinger.net>
References: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
         <20170417000700.29057-13-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-04-16 at 19:06 -0500, Larry Finger wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Fix alignment for coding style consistency.

aside:

Are all the btcoexist variants for this code identical?

8192e2ant.c 8723b1ant.c 8723b2ant.c 8821a1ant.c 8821a2ant.c

Maybe some of these functions should be centralized.

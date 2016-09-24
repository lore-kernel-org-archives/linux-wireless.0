Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:48707 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758012AbcIXQP6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Sep 2016 12:15:58 -0400
Message-ID: <1474733754.23838.3.camel@perches.com> (sfid-20160924_181625_206065_B45261C4)
Subject: Re: [PATCH] realtek: Add switch variable to 'switch case not
 processed' messages
From: Joe Perches <joe@perches.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 24 Sep 2016 09:15:54 -0700
In-Reply-To: <20160924175555.01cae6dd@endymion>
References: <1474654333.1849.5.camel@perches.com>
         <d091f73a6adf3bdaa09ab0399c22a9fdfe9b188c.1474654979.git.joe@perches.com>
         <f98d2cf1-802a-93c1-b219-ec45aa417940@lwfinger.net>
         <1474657363.1849.9.camel@perches.com> <20160924175555.01cae6dd@endymion>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-09-24 at 17:55 +0200, Jean Delvare wrote:
> Would it make sense to explicitly set the enum values, or add them as
> comments, to make such look-ups easier?

If you want to create enum->#ENUM structs and
"const char *" lookup functions, please be my guest.

otherwise, hex is at least a consistent way to display
what should be infrequent output.

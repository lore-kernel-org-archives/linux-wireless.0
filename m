Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:46729 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752223AbdDQR2r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2017 13:28:47 -0400
Message-ID: <1492450106.8661.11.camel@perches.com> (sfid-20170417_192913_023003_4E1C3A92)
Subject: Re: [PATCH 12/13] rtlwifi: btcoex: 21a 1ant: fix some coding style
 issues
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Date: Mon, 17 Apr 2017 10:28:26 -0700
In-Reply-To: <869a1d9b-79dc-9d5a-c4f3-efb99c1b1ff7@lwfinger.net>
References: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
         <20170417000700.29057-13-Larry.Finger@lwfinger.net>
         <1492445382.8661.9.camel@perches.com>
         <869a1d9b-79dc-9d5a-c4f3-efb99c1b1ff7@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-17 at 12:13 -0500, Larry Finger wrote:
> On 04/17/2017 11:09 AM, Joe Perches wrote:
> > On Sun, 2017-04-16 at 19:06 -0500, Larry Finger wrote:
> > > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > > 
> > > Fix alignment for coding style consistency.
> > 
> > aside:
> > 
> > Are all the btcoexist variants for this code identical?
> > 
> > 8192e2ant.c 8723b1ant.c 8723b2ant.c 8821a1ant.c 8821a2ant.c
> > 
> > Maybe some of these functions should be centralized.
> 
> They are not identical, but some of the functions could certainly be centralized.

I was writing specifically about functions not modules.

> The problem is that the btcoex software at Realtek is multi platform, and 
> written by a group that has not been too eager to implement this kind of 
> suggestion. If we were to force the issue, then the maintenance load on the 
> separate Linux group at Realtek would be greatly increased. This current set of 
> updates has already been delayed for at least two years while they found the 
> resources to be able to adhere to the "small change" policy of Linux. For that 
> reason alone, I would not be in favor of forcing the issue.

No worries, it just looked pretty mindless to copy/paste
relatively large blocks of code and then do trivial
whitespace fixes to them individually and separately.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:55296 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755971Ab3GOMX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 08:23:59 -0400
Message-ID: <1373891038.2062.7.camel@joe-AO722> (sfid-20130715_142402_481730_4C4326B6)
Subject: Re: [PATCH] brcmsmac: Further reduce log spam from tx phy messages
From: Joe Perches <joe@perches.com>
To: John Greene <jogreene@redhat.com>
Cc: linville@tuxdriver.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Date: Mon, 15 Jul 2013 05:23:58 -0700
In-Reply-To: <51E3E7F0.7050308@redhat.com>
References: <1373640919-2685-1-git-send-email-jogreene@redhat.com>
	 <1373652022.2614.13.camel@joe-AO722> <51E3E7F0.7050308@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-15 at 08:15 -0400, John Greene wrote:
> On 07/12/2013 02:00 PM, Joe Perches wrote:
> > On Fri, 2013-07-12 at 10:55 -0400, John Greene wrote:
[]
> > Just trivia:
> >> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> > []
> >> @@ -928,7 +928,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
> > []
> >> -			brcms_err(wlc->hw->d11core,
> >> +			brcms_dbg_ht(wlc->hw->d11core,
> >>   				  "%s: ampdu tx phy error (0x%x)\n",
> >>   				  __func__, txs->phyerr);
> >
> > Please keep the indentation of the arguments of
> > the same statement aligned to the open parenthesis.
[]
> Thanks Joe. My oversight.  I wish the checkpatch flagged this stuff. 

It does if you use the --strict option.



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34346 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbcFPQEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 12:04:46 -0400
Date: Thu, 16 Jun 2016 21:34:31 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix a typo in spectral code commments
Message-ID: <20160616160430.GA10584@atheros-ThinkPad-T61> (sfid-20160616_180456_739854_461B5839)
References: <1465882434-594-1-git-send-email-mohammed@qca.qualcomm.com>
 <20160616155958.GA24359@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160616155958.GA24359@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 16, 2016 at 11:59:59AM -0400, Bob Copeland wrote:
> On Tue, Jun 14, 2016 at 11:03:54AM +0530, Mohammed Shafi Shajakhan wrote:
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > 
> > Found this obvious typo while going through the spectral
> > code design in ath10k
> 
> >  		/* TODO: As experiments with an analogue sender and various
> > -		 * configuaritions (fft-sizes of 64/128/256 and 20/40/80 Mhz)
> > +		 * configurations (fft-sizes of 64/128/256 and 20/40/80 Mhz)
> >  		 * show, the particular configuration of 80 MHz/64 bins does
> >  		 * not match with the other smaples at all. Until the reason
> >  		 * for that is found, don't report these samples.
> 
> Also "smaples" :)

[shafi]  goodness me will that as well !

> 
> -- 
> Bob Copeland %% http://bobcopeland.com/

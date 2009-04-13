Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23101.mail.ird.yahoo.com ([217.146.189.41]:32470 "HELO
	web23101.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751836AbZDMHuc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 03:50:32 -0400
Message-ID: <657164.70021.qm@web23101.mail.ird.yahoo.com> (sfid-20090413_095037_639304_C6663FAC)
Date: Mon, 13 Apr 2009 00:43:50 -0700 (PDT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFT/RFC] rtl8187: Remove redundant quality calculation
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- On Mon, 13/4/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Now that mac80211 does the link
> quality calculation, that code can be
> removed from this driver. In addition, the signal noise
> calculation
> used by the vendor driver has been implemented for
> RYL8187B. The value
> for RTL8187L is fictional.

typo - 'RTL8187B'.

> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Am running the patch ATM.


      

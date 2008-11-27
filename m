Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:50531 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbYK0Oh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 09:37:29 -0500
Message-ID: <492EB0A7.6050301@lwfinger.net> (sfid-20081127_153736_947177_F229947A)
Date: Thu, 27 Nov 2008 08:37:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT][RFC][PATCH] p54: utilize cryptographic accelerator
References: <200811242215.00475.chunkeey@web.de> <492DE6BD.5060206@lwfinger.net> <200811271226.05700.chunkeey@web.de>
In-Reply-To: <200811271226.05700.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> Thanks... I guess the final RFT/RFC will be ready on friday/saturday.
> there are a two outstanding issues:
> 	- do we need to swap CCMP's IV as well?
> 	- does MIC failure & replay detection work?
> 		(or did you test that, when you were working with TKIP?)

No.

Larry

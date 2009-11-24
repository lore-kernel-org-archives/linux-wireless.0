Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:63766 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbZKXFtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 00:49:23 -0500
Received: by ywh12 with SMTP id 12so6075982ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 21:49:29 -0800 (PST)
Message-ID: <4B0B73E6.9060307@lwfinger.net>
Date: Mon, 23 Nov 2009 23:49:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Peter Lemenkov <lemenkov@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43legacy: Fix problem for PPC architecture noted in
 Red 	Hat Bugzilla #538523
References: <4b0b2bfc.wTVOnoPYuzV3oG6G%Larry.Finger@lwfinger.net> <adf480660911232137x5459441chde17fb77004e3cb4@mail.gmail.com>
In-Reply-To: <adf480660911232137x5459441chde17fb77004e3cb4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2009 11:37 PM, Peter Lemenkov wrote:
> 
> Seems that b43 has similar issue(s):
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=539267
> 

That one has already been addressed by mainline commit no.
d50bae33d1358b909ade05ae, and sent on to stable.

Thanks for the notification,

Larry

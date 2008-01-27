Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:36932 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753912AbYA0Sxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 13:53:50 -0500
Date: Sun, 27 Jan 2008 19:51:45 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH 2/2] rc80211-pid: add sanity check
Message-ID: <20080127195145.21c1a667@morte> (sfid-20080127_185354_770458_2A7165DD)
In-Reply-To: <479CB7A0.6090000@lwfinger.net>
References: <20080126040534.005e6736@morte>
	<479CB7A0.6090000@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Jan 2008 09:56:00 -0700
Larry Finger <larry.finger@lwfinger.net> wrote:

> Although the real cause of the bug is due to selecting a trial value for the new rate that can never 
> be satisfied, I think that this sanity check is a reasonable way to detect and stop the runaway. As 
> this condition is likely to affect a lot of systems, I think the WARN_ON(1) should be removed from 
> the final version of the patch. With it in, a lot of logs will get spammed.

Agreed. I'm going to post a quite different patch which aims to solve the
root cause. John, please disregard this one.


--
Ciao
Stefano

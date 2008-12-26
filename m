Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:36328 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYLZOwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 09:52:30 -0500
Date: Fri, 26 Dec 2008 16:52:26 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Fabio Rossi <rossi.f@inwind.it>
cc: linux-wireless@vger.kernel.org
Subject: Re: RT2500 scan problem in 2.6.28
In-Reply-To: <200812261342.43875.rossi.f@inwind.it>
Message-ID: <Pine.SOC.4.64.0812261651120.16847@math.ut.ee> (sfid-20081226_155241_035151_E8146E55)
References: <Pine.SOC.4.64.0812261259030.13693@math.ut.ee>
 <200812261342.43875.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> are you using the official kernel release or wireless-testing? In 

Official 2.6.28.

> wireless-testing there's included a patch for associating to hidden networks 
> when SSID=''. You can see the SSID value with iwlist <if> scanning.

Oh, so this is known - I'll just wait for it to be merged upstream then.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/

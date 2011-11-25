Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout7.freenet.de ([195.4.92.97]:41036 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab1KYOsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 09:48:54 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout7.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1RTx59-0002PS-C3
	for linux-wireless@vger.kernel.org; Fri, 25 Nov 2011 15:48:51 +0100
Received: from localhost ([::1]:43833 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RTx59-0001vO-9D
	for linux-wireless@vger.kernel.org; Fri, 25 Nov 2011 15:48:51 +0100
Received: from [195.4.92.22] (port=38559 helo=12.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RTx3A-0006Gp-No
	for linux-wireless@vger.kernel.org; Fri, 25 Nov 2011 15:46:48 +0100
Received: from p4fde0b80.dip0.t-ipconnect.de ([79.222.11.128]:56156 helo=mail.maya.org)
	by 12.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RTx3A-0000Rh-8Y
	for linux-wireless@vger.kernel.org; Fri, 25 Nov 2011 15:46:48 +0100
Message-ID: <4ECFAAC2.9070005@01019freenet.de> (sfid-20111125_154857_494194_C471FAB9)
Date: Fri, 25 Nov 2011 15:48:34 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: spamm of cfg80211: Calling CRDA to update world regulatory domain
References: <4EB00DD3.7090701@gmail.com>
In-Reply-To: <4EB00DD3.7090701@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Justin P. Mattock schrieb:
> is there a way to get rid of this annoying spamming of the regulatory?
> 
> 
> [  338.519037] cfg80211: Calling CRDA to update world regulatory domain
> [  338.523266] cfg80211: World regulatory domain updated:
> [  338.523269] cfg80211:     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [  338.523272] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [  338.523276] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [  338.523279] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [  338.523281] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [  338.523284] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)

I can see these messages with compat-wireless-2011-11-22, two. They are
sent out every 3 or 4 seconds. compat-wireless-2011-10-31 doesn't show
the problem.


Andreas

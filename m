Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:43351 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011AbZBXQgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 11:36:00 -0500
Message-ID: <49A421ED.7000801@lwfinger.net> (sfid-20090224_173604_543220_78E3BE45)
Date: Tue, 24 Feb 2009 10:35:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
CC: Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: More data on open-source firmware crash
References: <49A1A331.9080205@lwfinger.net> <80C13710-6BA9-4F14-95B5-82C3043CE93B@ing.unibs.it> <49A41F1D.9060300@lwfinger.net> <03E07CC7-A971-4EDD-9363-628B61E94A92@ing.unibs.it>
In-Reply-To: <03E07CC7-A971-4EDD-9363-628B61E94A92@ing.unibs.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francesco Gringoli wrote:
> What about drop info from dmesg? Another try could be halve the dma
> queue, I believe now it is 64 slots. Could you give a try setting it to 32?

The RX DMA queue was 64 and TX was 256. Both will be 32 in my next run.

I don't understand the "drop info from dmesg" part.

Larry


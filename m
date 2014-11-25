Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp27.msg.oleane.net ([62.161.4.27]:49261 "EHLO
	smtp27.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaKYLSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 06:18:37 -0500
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp27.msg.oleane.net (MTA) with ESMTP id sAPBIYt0006634
	for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 12:18:34 +0100
Subject: Question : WMM queue management in AP role
Date: Tue, 25 Nov 2014 12:18:34 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A31901925A6D@sbs2003.acksys.local> (sfid-20141125_121955_074682_2DA84B28)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

The AP role can manage several sta.
In case of WMM, each sta have a separate queue or all sta use the same
queue? 

Where can I found any information on the WMM queue management in linux
wireless?

I'm using ath9k driver.

Cedric Voncken


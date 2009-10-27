Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hosting.visp.net.lb ([194.146.153.11]:47913 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbZJ0DI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 23:08:28 -0400
From: Denys Fedoryschenko <denys@visp.net.lb>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ath5k, too high output power?
Date: Tue, 27 Oct 2009 05:08:28 +0200
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
References: <200910270259.09787.denys@visp.net.lb> <200910270410.24274.denys@visp.net.lb> <43e72e890910261959s6490b900xebb365d288c03f@mail.gmail.com>
In-Reply-To: <43e72e890910261959s6490b900xebb365d288c03f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910270508.29029.denys@visp.net.lb>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 October 2009 04:59:20 Luis R. Rodriguez wrote:
> You mean can you do antenna diversity and select this manually ? I am
> not sure, but I doubt it, should be easy to add though.

Yes, on some laptops wireless card connected really weird way. And while on 
Windows everything worked fine, on Linux signal was too weak, and some people 
thinking it is driver issue. 
I had this issue with madwifi before, and choosing antenna manually helped. 
But it was long time ago, no idea if it's useful now in ath5k. But in custom 
boards like Routerboard it is very useful.


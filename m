Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3H1Gnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 02:43:55 -0400
Message-ID: <1377672233.13797.4.camel@jlt4.sipsolutions.net> (sfid-20130828_084358_750428_958156DD)
Subject: Re: NGFF based WLAN module
From: Johannes Berg <johannes@sipsolutions.net>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Aug 2013 08:43:53 +0200
In-Reply-To: <521E16F50200009200026750@soto.provo.novell.com> (sfid-20130828_072756_206141_92BC02A8)
References: <521E16F50200009200026750@soto.provo.novell.com>
	 (sfid-20130828_072756_206141_92BC02A8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-27 at 23:27 -0600, Matt Chen wrote:
> Hi,
> 
> 
> 
> I have a NGFF WLAN module, Intel Wilkins Peak 2, I am wondering how to =
> 
> enable it. I found there is nothing from the lspci result. Is there any =
> 
> way to enable it in Linux ?

It should just be a regular PCIe device afaik, so maybe there's
something wrong with your system?

johannes


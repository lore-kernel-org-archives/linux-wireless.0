Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:27498 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbYLLBsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 20:48:01 -0500
Received: by ti-out-0910.google.com with SMTP id b6so810616tic.23
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 17:47:58 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18753.49741.50254.587004@localhost.localdomain> (sfid-20081212_024811_053296_0B6FDAEB)
Date: Fri, 12 Dec 2008 07:15:49 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jouni.malinen@atheros.com, lrodriguez@atheros.com,
	tomas.winkler@intel.com
Subject: Re: [RFC v2] mac80211: Fix HT channel selection
In-Reply-To: <1229022470.8081.65.camel@johannes.berg>
References: <18750.13163.213759.181839@localhost.localdomain>
	<1228818258.22164.178.camel@johannes.berg>
	<18750.46333.603462.143624@localhost.localdomain>
	<1229022470.8081.65.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> tried, it pushed ~2.9 MByte/sec TCP from my AP which isn't a lot... Then
> it crashed (see below). I say we put the patch in.
> 

No wait, I really don't want to introduce a regression in iwlwifi, will
look into this and see if moving their ht conf to config() causes trouble.

Sujith

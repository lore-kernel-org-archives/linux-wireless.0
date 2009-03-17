Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:45076 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZCQNcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 09:32:25 -0400
Received: by ti-out-0910.google.com with SMTP id i7so1630tid.23
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 06:32:22 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18879.42683.919616.530584@gargle.gargle.HOWL> (sfid-20090317_143228_562038_E4513CEE)
Date: Tue, 17 Mar 2009 19:03:47 +0530
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Luis.Rodriguez@Atheros.com
Subject: Re: Missing commits in wireless-testing
In-Reply-To: <20090317130228.GA3549@tuxdriver.com>
References: <18879.15297.344575.231076@gargle.gargle.HOWL>
	<20090317130228.GA3549@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> I just went through a (very painful) pseudo-rebase to 2.6.29-rc8
> last night.  I'm fairly confident that what is there now matches what
> was there before.
> 
> What commit do you think is missing?  What is it's subject line?

The serialization patches from Luis:

ath9k: implement IO serialization
ath9k: AR9280 PCI devices must serialize IO as well
ath9k: remove dummy PCI "retry timeout" fix

The code changes are present in wireless-testing, but the git SHA1 IDs
seem to be absent.

Sujith

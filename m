Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43572 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0KITPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 14:15:12 -0500
Date: Tue, 9 Nov 2010 13:57:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Clyde McPherson <ccmcphe@verizon.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless and RFKILL
Message-ID: <20101109185750.GA2374@tuxdriver.com>
References: <4CD99096.5020105@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CD99096.5020105@verizon.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 09, 2010 at 01:19:02PM -0500, Clyde McPherson wrote:

> I build and use the compat-wireless source for use with SBC
> applications, and I have a question about the wireless portion of
> the code. Our SBCs do not have RFKILL capabilities, and since we use
> wireless we are forced to include it in our kernel due to the
> depends in wireless. What are the chances of adding #ifdef's for
> CONFIG_RFKILL on the code segments that require RFKILL, this way
> integrators like myself would not need to load and/or build the
> rfkill modules? This would also save us memory and storage that is
> limited on a SBC system.

Why can't you just turn-off CONFIG_RFKILL?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

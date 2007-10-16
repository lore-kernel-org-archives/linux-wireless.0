Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:60159 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762624AbXJPRlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 13:41:24 -0400
Date: Tue, 16 Oct 2007 10:39:43 -0700
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlist and network-manager bug report
Message-ID: <20071016173943.GA20898@bougret.hpl.hp.com> (sfid-20071016_184128_756273_C3E3B83B)
Reply-To: jt@hpl.hp.com
References: <1189526874.6161.30.camel@johannes.berg> <20071016005711.GA10957@bougret.hpl.hp.com> <20071016165803.GA5677@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071016165803.GA5677@tuxdriver.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 16, 2007 at 12:58:03PM -0400, John W. Linville wrote:
> 
> Because of the confusion in SSID handling when WEXT was defined,
> WEXT is just never going to support a 32-byte SSID unless it happens
> to end in a NULL.  Sorry.

	Actually, you did not read the bug report and you are totally
wrong on that. We currently can not support 32-byte ESSID at all,
regardless of the NUL termination. Please try it.

	Jean

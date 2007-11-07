Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.mandriva.com ([212.85.150.183]:50864 "EHLO mx1.mandriva.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbXKGAjx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 19:39:53 -0500
From: Claudio Matsuoka <claudio@mandriva.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: RTL8187 rate control problems
Date: Tue, 6 Nov 2007 22:39:11 -0200
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	dsd@gentoo.org, kune@deine-taler.de
References: <200711061323.16302.claudio@mandriva.com> <20071106164148.GB4440@tuxdriver.com>
In-Reply-To: <20071106164148.GB4440@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711062239.13052.claudio@mandriva.com> (sfid-20071107_003959_988900_A9D1069F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 November 2007 14:41:48 John W. Linville wrote:

> I think you are right -- it looks like rtl8187 never sets
> excessive_retries for transmit status.  I don't see anything obvious
> in the specs that would give us an actual indication of that either,
> which probably explains why it is missing.

Yes, I thought so. I checked the Realtek site and these specs are not 
published there, are they restricted for some reason or can I have a look at 
them?



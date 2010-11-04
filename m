Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab0KDNuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 09:50:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
Reply-To: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Question about wireless configuration
References: <4CD2B6E9.9080303@lwfinger.net>
In-Reply-To: <4CD2B6E9.9080303@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Date: Thu, 04 Nov 2010 09:50:39 -0400
Message-Id: <1288878640.10023.2.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I am trying to test the latest Realtek driver for the RTL8187L. In order
> for the driver to be able to scan, CONFIG_WIRELESS_EXT must be set to
> "y". I could find no way to do that with the kernel configuration
> utilities until I made the following patch. I know it is wrong, but I
> would like to know the correct way.

There is no correct way, drivers that need it will select it in kconfig which obviously doesn't work for out-of-tree drivers.

Johannes


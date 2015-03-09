Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbCIRUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 13:20:05 -0400
Message-ID: <1425921599.32409.4.camel@redhat.com> (sfid-20150309_182009_967855_4CE94DF4)
Subject: Re: Virtual Interfaces with iwlwifi
From: Dan Williams <dcbw@redhat.com>
To: Risse Kilian <krisse@student.ethz.ch>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 09 Mar 2015 12:19:59 -0500
In-Reply-To: <C768C63E9A2F584FACC2A65D915E5A2830535975@MBX13.d.ethz.ch>
References: <C768C63E9A2F584FACC2A65D915E5A2830535956@MBX13.d.ethz.ch>
	 <C768C63E9A2F584FACC2A65D915E5A2830535975@MBX13.d.ethz.ch>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 16:53 +0000, Risse Kilian wrote:
> Hi
> 
> I tried to create a second interface and connect to another AP. But I was unable to do so. As I tried to enable the second interface I got an error: Device or resource busy. So am I right assuming that this is not possible with the iwlwifi driver?

What specific hardware do you have?
What kernel version do you have?
What specific command were you using to create the second interface?
What are the "software interface modes" and "valid interface
combinations" sections output from "iw phy0 info"?

It's certainly possible and supported with iwlwifi, but it depends on
specific hardware, the driver, etc.

Dan


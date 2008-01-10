Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37557 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466AbYAJT3f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 14:29:35 -0500
From: Michael Buesch <mb@bu3sch.de>
To: ronald645@gmail.com
Subject: Re: Bcm4311 shuts down on closing lid (intended?)
Date: Thu, 10 Jan 2008 20:28:43 +0100
Cc: linux-wireless@vger.kernel.org
References: <47866FE6.4010100@gmail.com>
In-Reply-To: <47866FE6.4010100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801102028.43222.mb@bu3sch.de> (sfid-20080110_192938_886519_E860654F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 January 2008 20:20:06 Ronald wrote:
> Hi,
> 
> The b43 driver in the linux kernel 2.6.24-rc7 works really good :) . 
> Keep it up! However, one thing is bugging me: Why does the card stop 
> sending/receiving packets when I close the lid? Is this behaviour 
> intended in the new driver? If yes, can I disable it?

I guess the machine goes to suspend, right?
You obviously can't use the machine when it's suspended.

-- 
Greetings Michael.

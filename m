Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:52630 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934154AbZKXW4Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 17:56:16 -0500
Message-ID: <4B0C6493.7010805@erley.org>
Date: Tue, 24 Nov 2009 17:56:19 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Simon Perreault <simon.perreault@viagenie.ca>
CC: linux-wireless@vger.kernel.org
Subject: Re: Hardware for 802.11s
References: <4B0C5E6F.5040302@viagenie.ca>
In-Reply-To: <4B0C5E6F.5040302@viagenie.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Perreault wrote:
> Hello,
> 
> I want to run 802.11s.
> 
> I tried a pair of Linksys WRT54GL v1.1 (Broadcom 5352) with the b43 driver,
> kernel 2.6.30.9, OpenWRT trunk (r18526). Doesn't work. I don't see anything in
> "iw ... station dump".
> Side question: is this expected behaviour?
> 
> Can anyone recommend something I can buy on which 802.11s will work? I couldn't
> Google anyone saying e.g. "I used the ACME Router 1.0 and it worked."

I don't have time tonight, but I believe you can make b43 work by triggering a 
scan after bringing the interface up.  I know I've made b43 work in the past.

Pat Erley




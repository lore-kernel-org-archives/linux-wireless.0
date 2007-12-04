Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbXLDPBt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 10:01:49 -0500
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200712041153.24896.hs4233@mail.mn-solutions.de>
References: <200712041140.07516.hs4233@mail.mn-solutions.de>
	 <200712041153.24896.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 09:56:38 -0500
Message-Id: <1196780198.26155.17.camel@localhost.localdomain> (sfid-20071204_150155_752572_9BF6ACA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-12-04 at 11:53 +0100, Holger Schurig wrote:
> 7. escape_ssid()
> 
> This code from ieee80211 is used in various debug messages.
> Should I re-implement this locally in the driver?

Part of the _point_ of depending on ieee80211 was so that we wouldn't
have a lot of pointless code duplication.  Like this.

Dan



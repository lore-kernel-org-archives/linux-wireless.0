Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3983 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbXLDP0X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 10:26:23 -0500
Date: Tue, 4 Dec 2007 10:25:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
Message-ID: <20071204152538.GF19911@tuxdriver.com> (sfid-20071204_152625_949526_A1849EC3)
References: <200712041140.07516.hs4233@mail.mn-solutions.de> <200712041153.24896.hs4233@mail.mn-solutions.de> <1196780198.26155.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196780198.26155.17.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2007 at 09:56:38AM -0500, Dan Williams wrote:
> On Tue, 2007-12-04 at 11:53 +0100, Holger Schurig wrote:
> > 7. escape_ssid()
> > 
> > This code from ieee80211 is used in various debug messages.
> > Should I re-implement this locally in the driver?
> 
> Part of the _point_ of depending on ieee80211 was so that we wouldn't
> have a lot of pointless code duplication.  Like this.

ACK

We've been talking about a new component for this kind of
shared generic 802.11 code for some time.  In my head I call it
"lib80211". :-)

Maybe it is time to start it?  The header of a thousand bytes start
with a single char... :-)

John
-- 
John W. Linville
linville@tuxdriver.com

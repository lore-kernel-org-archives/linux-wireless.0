Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:60171 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085AbaHZXie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 19:38:34 -0400
Date: Tue, 26 Aug 2014 19:37:55 -0400
From: Jim Rees <rees@umich.edu>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Subject: Re: iwlwifi 35% loss rate after v3.16-rc5
Message-ID: <20140826233755.GB7363@umich.edu> (sfid-20140827_013839_438094_33405793)
References: <20140826020721.GA1490@umich.edu>
 <1409032360.32368.2.camel@dubbel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409032360.32368.2.camel@dubbel>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho wrote:

  Also, any chance you can get sniffer logs of the problem?

It's here:
http://jim.rees.org/airportSniffyHlDMa.pcap

The Thinkpad is 00:24:d7:11:43:04, the AP (which I'm pinging) is
2C:67:FB:D1:70:56. The first 19 pings work, then it skips 5, then resumes.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:57780 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbaHZLmH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 07:42:07 -0400
Date: Tue, 26 Aug 2014 07:41:23 -0400
From: Jim Rees <rees@umich.edu>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Subject: Re: iwlwifi 35% loss rate after v3.16-rc5
Message-ID: <20140826114123.GA2737@umich.edu> (sfid-20140826_134212_537665_84A9550C)
References: <20140826020721.GA1490@umich.edu>
 <1409032360.32368.2.camel@dubbel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409032360.32368.2.camel@dubbel>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho wrote:

  This is probably the commit that is to blame:
  
  43d826c iwlwifi: dvm: don't enable CTS to self
  
  Could you try again without just that one? If it's confirmed we can
  revert that patch.

Yes, reverting that one commit fixes it.
  
  Also, any chance you can get sniffer logs of the problem?

I would be happy to if you can give me a hint how to do it. Do you just mean
a pcap, or something else?

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3LQHUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 02:20:08 -0500
Message-ID: <1387264797.4749.0.camel@jlt4.sipsolutions.net> (sfid-20131217_082012_407831_D3B5B60F)
Subject: Re: [BUG] P2P setup timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Ujjal Roy <royujjal@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 17 Dec 2013 08:19:57 +0100
In-Reply-To: <52AFE619.1060104@gmail.com> (sfid-20131217_065027_262928_A0D43F31)
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>
		 <1387197416.4665.15.camel@jlt4.sipsolutions.net>
		 <CANq1E4TAt_Pw-V5_2LtJjY3LRcuwsxr1mBkcHjmX+MJUxc=zPQ@mail.gmail.com>
		 (sfid-20131216_143914_205158_56AAC54B) <1387201528.2057.1.camel@jlt4.sipsolutions.net>
	 <52AFE619.1060104@gmail.com> (sfid-20131217_065027_262928_A0D43F31)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-17 at 11:20 +0530, Ujjal Roy wrote:
> Hi Johannes,
> 
> On 12/16/2013 07:15 PM, Johannes Berg wrote:
> > On Mon, 2013-12-16 at 14:39 +0100, David Herrmann wrote:
> >
> > Right, and I suspect they don't get a response because (as the sniffer
> > trace tells me) they're sent with 1 Mbps (a CCK rate), which is invalid
> > in the P2P spec (must use OFDM).
> >
> 
> Can you please let me know, is the P2P spec freely available to read or 
> download? If so, please provide some info from where I can able to get 
> the document. Actually, I need to know - how to add P2P_DEVICE support 
> in a driver.

No, it isn't. However, P2P_DEVICE support is not described in the spec
anyway since it's a Linux thing.

johannes


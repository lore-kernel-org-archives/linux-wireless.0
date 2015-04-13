Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:37652 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752193AbbDMMGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 08:06:36 -0400
Date: Mon, 13 Apr 2015 15:04:46 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Johannes Berg <johannes@sipsolutions.net>
cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	matti.gottlieb@intel.com
Subject: Re: [PATCH 1/4] ipv4: add option to drop unicast encapsulated in L2
 multicast
In-Reply-To: <1428922636.2355.7.camel@sipsolutions.net>
Message-ID: <alpine.LFD.2.11.1504131437040.1627@ja.home.ssi.bg> (sfid-20150413_140644_225196_7B5ECC62)
References: <1428652454-1224-1-git-send-email-johannes@sipsolutions.net>   <alpine.LFD.2.11.1504101445330.1538@ja.home.ssi.bg>  <1428671435.1890.22.camel@sipsolutions.net>  <alpine.LFD.2.11.1504111305440.2449@ja.home.ssi.bg>
 <1428922636.2355.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


	Hello,

On Mon, 13 Apr 2015, Johannes Berg wrote:

> > - CLUSTERIP works in LOCAL_IN (after ip_rcv_finish), LOCAL_IN
> > is here: ip_rcv_finish->dst_input->ip_local_deliver->
> > ip_local_deliver_finish
> 
> It's just that the later this is, the more nervous I get about it being
> really effective. :)
> 
> I'm willing to discount the CLUSTERIP case, it seems insane to want to
> run CLUSTERIP over wifi on a network that explicitly limits multicast.
> 
> Other than that, do you see any reason for not putting it in
> ip_rcv_finish()?

	ok, I don't remember for other cases.

Regards

--
Julian Anastasov <ja@ssi.bg>

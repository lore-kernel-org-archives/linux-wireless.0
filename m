Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44863 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaEVPZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 11:25:45 -0400
Message-ID: <1400772331.4174.38.camel@jlt4.sipsolutions.net> (sfid-20140522_172550_334104_493DDE7F)
Subject: Re: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	Thomas Pedersen <thomas@noack.us>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 22 May 2014 17:25:31 +0200
In-Reply-To: <CAGnRvur6zFrUUbSLzC=PddHqO46k5RbQM+RY19o_hqZxbQnzHw@mail.gmail.com> (sfid-20140522_172136_696770_B3DD90A6)
References: <3893194.GDQagdLGN9@desktop.local>
	 <1400771757.4174.37.camel@jlt4.sipsolutions.net>
	 <CAGnRvur6zFrUUbSLzC=PddHqO46k5RbQM+RY19o_hqZxbQnzHw@mail.gmail.com>
	 (sfid-20140522_172136_696770_B3DD90A6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 17:21 +0200, Henning Rogge wrote:
> Ups...
> 
> I thought I had found all this "stupid whitespace mistakes, I will
> remove them in the next version of the patch... 

:)

> but I wanted a comment
> if this is a good direction to go before we discuss how to change the
> netlink interface to export the data of the former mpp_paths table.

No idea, really. However, I'm not sure why the two are related? The
netlink API could just iterate two tables as well.

johannes


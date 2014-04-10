Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40746 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935719AbaDJTva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 15:51:30 -0400
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id C593320A20
	for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 15:51:29 -0400 (EDT)
Date: Thu, 10 Apr 2014 12:54:02 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Andev <debiandev@gmail.com>
Cc: Christian Engelmayer <cengelma@gmx.at>, linville@tuxdriver.com,
	fariyaf@gmail.com, dan.carpenter@oracle.com, joe@perches.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] rsi: Fix a potential memory leak in
 rsi_set_channel()
Message-ID: <20140410195402.GA17308@kroah.com> (sfid-20140410_215159_561988_86EF69B8)
References: <20140410203146.767149e7@spike>
 <CAJUuVQ5KW3v0DgwotDMow=rBvxoZKfYYD2misXbsMD6c1UaShw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJUuVQ5KW3v0DgwotDMow=rBvxoZKfYYD2misXbsMD6c1UaShw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 10, 2014 at 03:46:12PM -0400, Andev wrote:
> Adding Greg KH,

Why do I care about this?


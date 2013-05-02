Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab3EBQsK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 12:48:10 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130430075704.GH7237@elgon.mountain>
References: <20130430075704.GH7237@elgon.mountain>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: dhowells@redhat.com, Simon Kelley <simon@thekelleys.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] atmel: printing bogus information
Date: Thu, 02 May 2013 17:47:58 +0100
Message-ID: <11125.1367513278@warthog.procyon.org.uk> (sfid-20130502_184821_937420_6FB1ACBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> There was an extra ';' character added to the end of the if statement
> which means that it always prints that the /proc entry wasn't created
> even though it was.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

The patches have gone upstream, so send it Linuswards.

Acked-by: David Howells <dhowells@redhat.com>

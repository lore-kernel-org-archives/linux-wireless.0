Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17234 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaDJUHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 16:07:54 -0400
Date: Thu, 10 Apr 2014 23:07:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andev <debiandev@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
	Christian Engelmayer <cengelma@gmx.at>, linville@tuxdriver.com,
	fariyaf@gmail.com, joe@perches.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] rsi: Fix a potential memory leak in
 rsi_set_channel()
Message-ID: <20140410200722.GN4963@mwanda> (sfid-20140410_220800_335969_D3D3B7F8)
References: <20140410203146.767149e7@spike>
 <CAJUuVQ5KW3v0DgwotDMow=rBvxoZKfYYD2misXbsMD6c1UaShw@mail.gmail.com>
 <20140410195402.GA17308@kroah.com>
 <CAJUuVQ7xgRLDzwojDCdb3yhTm3HygypMLXyaRiErnVveNVz+sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJUuVQ7xgRLDzwojDCdb3yhTm3HygypMLXyaRiErnVveNVz+sQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 10, 2014 at 04:01:35PM -0400, Andev wrote:
> On Thu, Apr 10, 2014 at 3:54 PM, Greg Kroah-Hartman <greg@kroah.com> wrote:
> > On Thu, Apr 10, 2014 at 03:46:12PM -0400, Andev wrote:
> >> Adding Greg KH,
> >
> > Why do I care about this?
> >
> 
> I am not sure if this needs to be applied to stable too. Should I have
> cc'ed stable@?

Read Documentation/stable_kernel_rules.txt.

But for netdev, then Dave M. maintains a queue of patches which go to
stable.  So this would go through Dave's stable queue and he forwards
them to Greg.

regards,
dan carpenter


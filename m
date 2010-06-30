Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab0F3WWr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 18:22:47 -0400
Subject: Re: Problem with firmware load on ipw2200
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100629134930.GC5296@tuxdriver.com>
References: <4C29F711.1090306@lwfinger.net>
	 <20100629134930.GC5296@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 15:23:29 -0700
Message-ID: <1277936609.25199.11.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-29 at 09:49 -0400, John W. Linville wrote:
> On Tue, Jun 29, 2010 at 08:37:21AM -0500, Larry Finger wrote:
> > I'm trying to help an ipw2200 user on the openSUSE Wireless Forum and I'm
> > stuck. The system is failing to load the firmware with error -2 (File or
> > directory not found). The difficulty is that the required files are
> > present with the correct permissions.
> > 
> > What system component might be missing and/or borked to get this symptom?
> 
> selinux?

Or udev; basically whatever firmware helper is registered with the
kernel for firmware request handling.  Which these days I thought was
udev on most distros.

Dan



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZHMRUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 13:20:54 -0400
Subject: Re: Roaming behavior
From: Dan Williams <dcbw@redhat.com>
To: David Seira <davidseira@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20090813T094313-518@post.gmane.org>
References: <loom.20090811T124332-602@post.gmane.org>
	 <20090811135915.GC2684@tuxdriver.com> <1250003481.4185.7.camel@solid2>
	 <200908120907.18501.hs4233@mail.mn-solutions.de>
	 <1250061248.13529.94.camel@johannes.local>
	 <loom.20090813T094313-518@post.gmane.org>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 12:20:50 -0500
Message-Id: <1250184050.5896.28.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-13 at 09:44 +0000, David Seira wrote:
> 
> 
> But I haven't installed wpa_supplicant, I don't need it. In which files is
> roaming behavior implemented?

wpa_supplicant is the defacto wifi control program for Linux.  Yes, it
doesn't more than WPA.  Yes, it can be used for open and WEP networks.
If you don't use it, you'll just end up rewriting a large chunk of it.

Dan


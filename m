Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:47923 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbYFBDnS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2008 23:43:18 -0400
Date: Mon, 02 Jun 2008 12:42:47 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 3/3] PS3: gelic: Add support for ESSID scan
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	linux-wireless@vger.kernel.org, geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1212169904.8178.27.camel@localhost.localdomain>
References: <20080530162420.473C.40F06B3A@sm.sony.co.jp> <1212169904.8178.27.camel@localhost.localdomain>
Message-Id: <20080602123704.475F.40F06B3A@sm.sony.co.jp> (sfid-20080602_054325_377817_25AAE115)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 30 May 2008 13:51:44 -0400
Dan Williams <dcbw@redhat.com> wrote:

> On Fri, 2008-05-30 at 16:27 +0900, Masakazu Mokuno wrote:
> > This adds the support for ESSID scanning
> 
> You'll want to:
> 
> 	range->scan_capa = IW_SCAN_CAPA_ESSID;
> 
> in your SIOCGIWRANGE handler too.

I didn't notice that this flag already was merged in.
I'll respin.

Thanks for pointing out.

-- 
Masakazu Mokuno


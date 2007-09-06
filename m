Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:46891 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752622AbXIFRyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 13:54:19 -0400
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Date: Thu, 6 Sep 2007 10:54:22 -0700
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
References: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com> <200709041817.40366.inaky@linux.intel.com> <200709061847.53659.IvDoorn@gmail.com>
In-Reply-To: <200709061847.53659.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709061054.22492.inaky@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 September 2007, Ivo van Doorn wrote:
> >
> > Can you add 'uwb' [for ultrawideband radios]? That way I could start to use it. A
> > Doc file would help enourmously also :)
> 
> I'll create a doc file this weekend which will explain the sysfs files
> and some instructions for drivers that want to implement it.

Thanks,

> I'm not familiar with ultrawideband radios, don't they fall under the same
> catagory as wireless lan?

Nope, totally different beast; see linuxuwb.org. UWB is kind of like bluetooth 
on esteroids, for PAN applications. Wireless USB (for eaxmple) uses a UWB radio.

-- Inaky

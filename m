Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:23753 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754304AbXIESlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 14:41:47 -0400
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Date: Tue, 4 Sep 2007 18:17:39 -0700
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
References: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com> <f6ca9fed0709041118o2dcd4b18mcb25f2b93f648479@mail.gmail.com> <200709042058.15463.IvDoorn@gmail.com>
In-Reply-To: <200709042058.15463.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709041817.40366.inaky@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 September 2007, Ivo van Doorn wrote:
> On Tuesday 04 September 2007, dragoran wrote:
> > On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > On Tuesday 04 September 2007, dragoran wrote:
> > > > >+static ssize_t show_rf_kill(struct device *d,
> > >
> > > Yes. It currently is only missing users.
> > 
> > ok thats great ;) is the (userspace) interface defined somewhere? or
> > should I read the code to understand how it works? (would like to add
> > support to hal)
> 
> There isn't a documentation file for it, so best thing to do would be looking at the code.
> basically hal only needs to check the sysfs files:
> 
> 	name -> Name of device/interface
> 	type -> wlan, bluetooth, irda

Can you add 'uwb' [for ultrawideband radios]? That way I could start to use it. A
Doc file would help enourmously also :)

-- Inaky

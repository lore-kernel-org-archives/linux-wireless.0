Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:38251 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbXIFQha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 12:37:30 -0400
Received: by ug-out-1314.google.com with SMTP id z38so186115ugc
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2007 09:37:28 -0700 (PDT)
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Date: Thu, 6 Sep 2007 18:47:53 +0200
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
References: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com> <200709042058.15463.IvDoorn@gmail.com> <200709041817.40366.inaky@linux.intel.com>
In-Reply-To: <200709041817.40366.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709061847.53659.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 September 2007, Inaky Perez-Gonzalez wrote:
> On Tuesday 04 September 2007, Ivo van Doorn wrote:
> > On Tuesday 04 September 2007, dragoran wrote:
> > > On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > > On Tuesday 04 September 2007, dragoran wrote:
> > > > > >+static ssize_t show_rf_kill(struct device *d,
> > > >
> > > > Yes. It currently is only missing users.
> > > 
> > > ok thats great ;) is the (userspace) interface defined somewhere? or
> > > should I read the code to understand how it works? (would like to add
> > > support to hal)
> > 
> > There isn't a documentation file for it, so best thing to do would be looking at the code.
> > basically hal only needs to check the sysfs files:
> > 
> > 	name -> Name of device/interface
> > 	type -> wlan, bluetooth, irda
> 
> Can you add 'uwb' [for ultrawideband radios]? That way I could start to use it. A
> Doc file would help enourmously also :)

I'll create a doc file this weekend which will explain the sysfs files
and some instructions for drivers that want to implement it.

I'm not familiar with ultrawideband radios, don't they fall under the same
catagory as wireless lan?

Ivo

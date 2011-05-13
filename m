Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53911 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab1EMVaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 17:30:35 -0400
Received: by fxm17 with SMTP id 17so2026597fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 14:30:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: WPA in ad-hoc mode with carl9170
Date: Fri, 13 May 2011 23:30:28 +0200
Cc: linux-wireless@vger.kernel.org
References: <20110513160113.GA14293@zenon.in.qult.net> <20110513174041.GA4690@zenon.in.qult.net> <201105132231.48232.chunkeey@googlemail.com>
In-Reply-To: <201105132231.48232.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105132330.28531.chunkeey@googlemail.com> (sfid-20110513_233048_169235_260A3CAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 May 2011 22:31:47 Christian Lamparter wrote:
> On Friday 13 May 2011 19:40:41 Ignacy Gawedzki wrote:
> > On Fri, May 13, 2011 at 12:39:53PM -0400, thus spake Brian Prodoehl:
> > > Have you tested only with hw crypto?  Try passing the nohwcrypt param
> > > to the module while loading.
> > 
> > I just tried that and at first it seemed to make no difference.  But at some
> > point, one of the two nodes of my testbed started to send encrypted frames
> > (both broadcast and unicast) and the other node could receive them okay.
> > 
BTW: I hope your compat-wireless/wireless-testing.git is up to date. 
Nicolas Cavallari <Nicolas.Cavallari@lri.fr> has submitted a fix for
his ad-hoc setup recently, see: "carl9170: fix allmulticast mode".

Regards,
	Chr

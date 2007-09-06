Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:46683 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbXIFQof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 12:44:35 -0400
Received: by ug-out-1314.google.com with SMTP id z38so187338ugc
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2007 09:44:34 -0700 (PDT)
To: dragoran <drago01@gmail.com>
Subject: Re: rfkill interface (was Re: [PATCH V3] Add iwlwifi wireless drivers)
Date: Thu, 6 Sep 2007 18:54:45 +0200
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <f6ca9fed0709051233h69f66aebi45aac65ab1a96f0e@mail.gmail.com>
In-Reply-To: <f6ca9fed0709051233h69f66aebi45aac65ab1a96f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709061854.46058.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > By default the kernel will act when the rfkill button is pressed, it will loop
> > through all registered buttons of the same type and change the state.
> > Userspace can read the "state" sysfs file to see the current status,
> > but if a userspace tools wants to take control of taking action when the button is pressed,
> > or at least doesn't want the kernel to do anything, 1 should be written to "claim" to
> > tell the kernel that it should back off and ignore all events.
> 
> ok thx for explaining this will talk to the nm and hal people about it
> and see how they want things to work than I will create patches to
> implement it.
> which drivers support it now? rt2x00 and ?? or are they the only ones right now?

In wireless-dev it is currently only rt2x00,

But I have heard about work in progress for:
	wistron_btns
	thinkpad_acpi
	MSI S270

I am however not sure about their status.

Ivo

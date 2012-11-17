Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2KQJlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 04:41:08 -0500
Message-ID: <1353145302.9543.40.camel@jlt4.sipsolutions.net> (sfid-20121117_104113_712127_8303FD66)
Subject: Re: [RFC 00/14] mesh powersave - basics
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Sat, 17 Nov 2012 10:41:42 +0100
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:47 -0800, Marco Porsch wrote:
> The following commits cover the basic subset of functions, that each mesh node
> must support to communicate in the presence of power saving nodes.
> The current patchset does not implement any actual power savings yet (no
> hardware configuration, no doze state).

In addition to all the inline comments, the patch series ordering etc.
worries me. What happens if I run an inbetween snapshot? It seems to me
that could result in pretty inconsistent behaviour, in particular wrt.
userspace configuration being accepted but only partially (?) used etc.

johannes


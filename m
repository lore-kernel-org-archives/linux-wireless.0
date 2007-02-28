Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:32625 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbXB1Q0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:26:48 -0500
Received: by nf-out-0910.google.com with SMTP id o25so603061nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 08:26:47 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
Date: Wed, 28 Feb 2007 17:26:43 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13953.IvDoorn@gmail.com> <1172679380.5015.32.camel@johannes.berg>
In-Reply-To: <1172679380.5015.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281726.43619.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 17:16, Johannes Berg wrote:
> On Wed, 2007-02-28 at 15:07 +0100, Ivo van Doorn wrote:
> 
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
> > +	file->private_data = inode->i_private;
> > +#else
> > +	file->private_data = inode->u.generic_ip;
> > +#endif

Ouch.. :(

I'll resend this patch without KERNEL_VERSION stuff in it.

Ivo

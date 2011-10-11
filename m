Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:54289 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751528Ab1JKUds (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 16:33:48 -0400
Message-ID: <1318365227.8896.14.camel@Joe-Laptop> (sfid-20111011_223351_543668_3EC451A9)
Subject: Re: [PATCH v2 1/5] ath6kl: Add endpoint_stats debugfs file
From: Joe Perches <joe@perches.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 11 Oct 2011 13:33:47 -0700
In-Reply-To: <20111011185228.GA20806@jouni.qca.qualcomm.com>
References: <1318343517-15292-1-git-send-email-jouni@qca.qualcomm.com>
	 <1318343517-15292-2-git-send-email-jouni@qca.qualcomm.com>
	 <1318351171.1839.43.camel@Joe-Laptop>
	 <20111011185228.GA20806@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 21:52 +0300, Jouni Malinen wrote:
> On Tue, Oct 11, 2011 at 09:39:31AM -0700, Joe Perches wrote:
> > > +static unsigned int print_endpoint_stat(struct htc_target *target, char *buf,
> > > +					unsigned int buf_len, unsigned int len,
> > > +					int offset, const char *name)
> > Perhaps the function name is wrong.
> > This doesn't print, it fills a buffer.
> Well, it prints the stuff into a buffer just like scnprintf prints
> things.. Feel free to send a patch if you want to try to rename
> *print* functions ;-).

OK, s/print/scnprint/



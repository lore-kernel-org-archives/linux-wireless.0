Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:63172 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbXL3WBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2007 17:01:44 -0500
Received: by fk-out-0910.google.com with SMTP id z23so5002916fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2007 14:01:43 -0800 (PST)
To: chris2553@googlemail.com
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Sun, 30 Dec 2007 23:01:40 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <200712301311.42895.IvDoorn@gmail.com> <200712301926.45380.chris2553@googlemail.com>
In-Reply-To: <200712301926.45380.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712302301.40526.IvDoorn@gmail.com> (sfid-20071230_220153_215073_B5617DD1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Here is the patch against the latest vanilla kernel,
> > the previous piece of code was bugged since the header size check was
> > incorrect, but that is fixed in this one.
> >
> 
> Thanks. You'll be pleased to here that with this patch, the warning has gone 
> away and laptop's connection to my wireless network is still fine. I'll be 
> using it over the New Year holiday. If anything negative happens I'll let you 
> know.

excellent news, I have a few other patches currently under testing,
and if no big problems are reported with them rt2x00 2.6.14 will be
released at the end of this week.

Ivo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50938 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2KLWTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 17:19:04 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so9820834iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 14:19:04 -0800 (PST)
Message-ID: <50A175D4.8090404@lwfinger.net> (sfid-20121112_231909_701694_011B15DE)
Date: Mon, 12 Nov 2012 16:19:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Maxim Mikityanskiy <maxtram95@gmail.com>
CC: greg@kroah.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/17] RTL8187SE driver cleanups
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2012 03:58 PM, Maxim Mikityanskiy wrote:
> There are some bug fixes, cleanups and dead code removal for
> drivers/staging/rtl8187se

This comment applies to all 17 patches. The subject should be of the form

[PATCH XX/17] staging: rtl8187se: blah-blah

By using both staging and rtl8187se in the subject, it is a lot easier to search 
the git log.

I expect there will be comments on others of the series.

Larry



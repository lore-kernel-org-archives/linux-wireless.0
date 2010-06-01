Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51147 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab0FAST4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 14:19:56 -0400
Received: by fxm8 with SMTP id 8so1228517fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 11:19:55 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Greg Munroe" <gmunroe@keywcorp.com>
Subject: Re: Can't find firmware file
Date: Tue, 1 Jun 2010 20:19:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <4B6B69AB42555546BF8AEBDA21196517011624B5@ihq-app01.keywcorp.com>
In-Reply-To: <4B6B69AB42555546BF8AEBDA21196517011624B5@ihq-app01.keywcorp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201006012019.48194.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

please send questions to: linux-wireless@vger.kernel.org ,
else they'll go straight into the spam trash folder.

On Tuesday 01 June 2010 17:18:56 Greg Munroe wrote:
> I'm having trouble loading the firmware files when I compile the
> carl9170 driver into the kernel instead of being mod-loadable.
> If I build "CONFIG_CARL9170_USB=m", it has no trouble locating the
> firmware files in /lib/firmware.
> If I build "CONFIG_CARL9170_USB=y", it can't find the firmware files?
> Thanks again for the help,

http://lkml.org/lkml/2010/3/11/490 et seq. ?

Or: add the firmware into the kernel image.

Regards,
	Chr

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:45485 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0LHTxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 14:53:22 -0500
Received: by ewy10 with SMTP id 10so1194809ewy.4
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 11:53:21 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Chris Pechard <chrispechard@yahoo.com>
Subject: Re: carl9170fw: custom build incompatibility issue
Date: Wed, 8 Dec 2010 20:52:51 +0100
Cc: linux-wireless@vger.kernel.org
References: <368544.4876.qm@web120203.mail.ne1.yahoo.com>
In-Reply-To: <368544.4876.qm@web120203.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012082052.51358.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 08 December 2010 19:58:15 Chris Pechard wrote:
> I tried to build an unmodified carl9170fw firmware based on 1.9.0  
> tag.Unfortunately when dropping it in my /lib/firmware directory, I get  
> unsupported firmware when connecting my usb wifi device. If I used the  
> precompiled version based on the same tag, everything is working fine.  Below is 
> 
> the config I used to build the firmware. Any help to get this  working would be 
> appreciated.
> 

np, just attach carl9170's .config and the "broken" firmware file.

Regards,
	Chr

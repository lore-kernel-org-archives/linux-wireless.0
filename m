Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:46218 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab0LHU72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 15:59:28 -0500
Received: by ewy10 with SMTP id 10so1245494ewy.4
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 12:59:26 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Chris Pechard <chrispechard@yahoo.com>
Subject: Re: carl9170fw: custom build incompatibility issue
Date: Wed, 8 Dec 2010 21:59:09 +0100
Cc: linux-wireless@vger.kernel.org
References: <368544.4876.qm@web120203.mail.ne1.yahoo.com> <201012082052.51358.chunkeey@googlemail.com> <326185.97637.qm@web120219.mail.ne1.yahoo.com>
In-Reply-To: <326185.97637.qm@web120219.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201012082159.09406.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 08 December 2010 21:33:43 Chris Pechard wrote:
> Hi Christian,
> 
> this is the info you requested. 

The only thing wrong is the lack of fw metadata (which is kind of
obvious since the the firmware is somewhat customizable).


You have two options:

 - either concat carl9170.fw and carl9170.dsc into carl9170-1.fw
   (by hand).

 - autogen.sh install [also adds miniboot + fw checksum]
   (since CONFIG_CARL9170FW_MAKE_RELEASE is y,
	and CONFIG_CARL9170FW_RELEASE_VERSION=1)

Best Regards,
	Christian 

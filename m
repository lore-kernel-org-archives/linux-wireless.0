Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:36497 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZGaVER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:04:17 -0400
Received: by fxm17 with SMTP id 17so1592525fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 14:04:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907281808.35906.mb@bu3sch.de>
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com>
	 <200907281808.35906.mb@bu3sch.de>
Date: Fri, 31 Jul 2009 23:04:17 +0200
Message-ID: <83a869cd0907311404o793c1733p43e936437a923340@mail.gmail.com>
Subject: Re: [RESEND] [PATCHv2] b43 add harware tkip
From: gregor kowski <gregor.kowski@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael,

On 7/28/09, Michael Buesch <mb@bu3sch.de> wrote:
>> This add hardware tkip for b43.
>
> First of all, I don't really want to support hw tkip on b43.
> Broadcom removed the support for hw tkip from their drivers. I bet they
> had a very good reason to do so.
Did they remove it from the firmware or only the driver ?
May be they remove it to support advanced stuff like multiple SSID ?
Which version of the driver it is ?

> It's mapped to 4, because you removed the old API support.
> (I'm not sure whether we want to remove that support, yet. Gimme some time
> on it...)
>
Does the old API still useful ?
Are there v4 firmware supporting old API ?


Regards,

Gregor

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42976 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaF0R3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 13:29:42 -0400
Received: by mail-ob0-f176.google.com with SMTP id wm4so5966622obc.35
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2014 10:29:42 -0700 (PDT)
Message-ID: <53ADAA08.3080005@lwfinger.net> (sfid-20140627_192946_172459_EC4561B4)
Date: Fri, 27 Jun 2014 12:29:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Driver for Mediatek MT7630E
References: <2508403.0JHOuVQMG0@x750lb01> <53ACB8B0.7030007@lwfinger.net> <386D9605-ACF0-426B-8E30-5301F6881A46@gmail.com>
In-Reply-To: <386D9605-ACF0-426B-8E30-5301F6881A46@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/27/2014 01:53 AM, Gertjan van Wingerde wrote:
> Hi Larry,
>
> Although I stepped down as rt2x00 maintainer I'm still following developments.
> I noticed that Mediatek have published a Linux MT7630E driver on their website as well.
> This one seems to be a bit newer than the one in the github repo (at least it is based on a newer rt2x00 version).
> Maybe you should check that one out.

Gertjan,

Thanks for the notice. The link for that new driver was sent to me earlier and I 
have been investigating it. Unfortunately, neither it nor the older one are able 
to authenticate on my WPA or WPA2 APs. So much for the "easy" addition of the 
new device.

Larry



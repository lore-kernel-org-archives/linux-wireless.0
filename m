Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gretel.risen.be ([78.46.99.137]:34984 "EHLO gretel.risen.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932979Ab2EXQmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 12:42:15 -0400
Message-ID: <4FBE64C0.8000804@aquazul.com> (sfid-20120524_184232_967848_FB4DDB45)
Date: Thu, 24 May 2012 18:41:36 +0200
From: Mourad De Clerck <bugs-wireless@aquazul.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: firmware loading fails for b43 using linux 3.4?
References: <4FBD7772.6070305@aquazul.com> <4FBDA4FE.6040603@lwfinger.net> <4FBDBB48.8080004@aquazul.com> <4FBE36B8.8020208@lwfinger.net>
In-Reply-To: <4FBE36B8.8020208@lwfinger.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24/05/12 15:25, Larry Finger wrote:
> It may be a while before I sort out all the details of this fix. Until
> then, you can use either the temporary fix or compile b43 as a module.

Yes, no worries – I'm perfectly happy with the workaround of using b43 
as a module. I just wanted to follow through with it.

> I always have the wireless drivers built as modules. When making
> changes, one only needs to recompile, reinstall the new version, and
> unload/reload the module. If built into the kernel, a reboot is needed
> for every change. None the less, the code needs to handle all cases.

Yes, I figured as much… but that's why there's testers after all :)

In any case, thank you for your work on this…

Kind regards,

-- Mourad

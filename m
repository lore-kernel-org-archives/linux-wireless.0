Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64986 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaDZVk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2014 17:40:28 -0400
Received: by mail-ob0-f181.google.com with SMTP id gq1so5843449obb.12
        for <linux-wireless@vger.kernel.org>; Sat, 26 Apr 2014 14:40:27 -0700 (PDT)
Message-ID: <535C27C9.7010309@lwfinger.net> (sfid-20140426_234109_177331_5BAC2CE8)
Date: Sat, 26 Apr 2014 16:40:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nicolas Vaquero <nicovaq92@hotmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [BUG-FATAL ERROR] WiFi Realtek 8192 ---> Ubuntu 12.04 LTS
References: <BLU0-SMTP336B542CBA1B1F927CDFEAAA9450@phx.gbl>
In-Reply-To: <BLU0-SMTP336B542CBA1B1F927CDFEAAA9450@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2014 02:29 PM, Nicolas Vaquero wrote:
> Hello, I have a Philco PHN14C2 (notebook) and until Kernel 3.8.0-36 (inclusive)
> is all OK.
> When I upgrade Kernel to 3.8.0-37/38/39 I couldn't use WiFi, when I put it ON
> --> Console appear and I have to Turn it OFF (Forced HALT)
>
> I can't copy the stack trace cause the system stop responding.
>
> Sorry if I can't talk property.
>
>
> In Spanish:
>
> Hola, tengo una Philco PHN14C2 (Notebook) y hasta el Kernal 3.8.0-36 (inclusive)
> Todo andaba BIEN.
> Cuando actualicé a Kernel 3.8.0-37/37/39 no pude usar más el WiFi, porque cuando
> lo activo aparece la consola presentando un Stack Trace y el sistema deja de
> responder, por lo tanto debo apagarla forzadamente.
>
> Actualmente estoy usando Kernel 3.8.0-36.

Sorry, Realtek 8192 is not sufficient to determine what device you have. Is it 
USB or PCI? If USB, then post the output of 'lsusb'. If PCI, then post the 
output of '/sbin/lspci -nn'.

Do you see the fatal stack dump on the screen? If so, is it possible for you to 
photograph the screen and post that photo?

Larry


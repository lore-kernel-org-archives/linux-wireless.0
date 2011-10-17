Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:32828 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQSiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 14:38:10 -0400
Received: by ggnb1 with SMTP id b1so2545803ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 11:38:09 -0700 (PDT)
Message-ID: <4E9C761B.8000509@lwfinger.net> (sfid-20111017_203814_311557_9D0AA639)
Date: Mon, 17 Oct 2011 13:38:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: v4mp <gaigo88@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gm ail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T161652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net> <loom.20111017T115802-634@post.gmane.org> <4E9C42CF.5010702@lwfinger.net> <loom.20111017T190430-717@post.gmane.org>
In-Reply-To: <loom.20111017T190430-717@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/17/2011 12:09 PM, v4mp wrote:
>
>
> ok, i've checked the md5 checksum of the firmware and is ok,
> i give you dmesg at pastebin.com
>
> it has 2 parts: in the second part i can't see what is in previous of the error
>
> the link is: http://pastebin.com/7tfcBfbD

There are a number of USB errors, all occurring on the xhci controller. Do you 
have any USB ports on different controllers? What is the output of lsusb?

Larry


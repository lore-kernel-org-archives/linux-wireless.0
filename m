Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61753 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3K3Mpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 07:45:30 -0500
Received: by mail-vc0-f179.google.com with SMTP id ie18so7385715vcb.10
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 04:45:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com>
References: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Sat, 30 Nov 2013 16:45:09 +0400
Message-ID: <CAHNKnsTTUP9gCVcMbJB=bUs5onS=1GDDmc-yFwjQDuNzwyY7LQ@mail.gmail.com> (sfid-20131130_134605_479852_1DD4F8B0)
Subject: Re: wireless network interfaces and network namespaces
To: Kevin Wilson <wkevils@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2013/11/30 Kevin Wilson <wkevils@gmail.com>:
> I want to verify this: all wireless interfaces do no support
> network namespace. Is this true ? what in fact is the reason for this ?
>
Yes it is. You may use couple of virtual ethernet interfaces and
bridge to carry traffic between the process that is isolated in
separate namespace and a wireless interface.

--
BR,
Sergey

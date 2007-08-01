Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:21739 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbXHABU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 21:20:58 -0400
Received: by py-out-1112.google.com with SMTP id d32so95480pye
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 18:20:57 -0700 (PDT)
Message-ID: <43e72e890707311820h59eebf6raf5b77058e2d23dc@mail.gmail.com>
Date: Tue, 31 Jul 2007 21:20:57 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Edward Ando" <edwardando@fastwebnet.it>
Subject: Re: Removing the prism54 module
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070728224008.782a3be6@ed.anywhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070728224008.782a3be6@ed.anywhere>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/28/07, Edward Ando <edwardando@fastwebnet.it> wrote:
> Dear All,
> I am trying to set up software suspend 2 (TuxOnIce now it seems). This
> has decided it wants to remove the prism54 module before starting the
> hibernate process.
>
> When it tries to do this, (or when I manually do: "ifconfig eth1
> down"), I start getting these messages on all terminals, ad infinitum:
>
> kernel: unregister_netdevice: waiting for eth1 to become free. Usage
> count = 4

Hmm... can you show lsmod output please?

  Luis

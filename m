Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59598 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaEPEVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 00:21:12 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so305920wiw.10
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 21:21:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140515214105.GG15430@us.netrek.org>
References: <5346DED8.2030704@free.fr>
	<CAJwzM1k=OOBa7C3u0+TzmRUBwMYfJSMgB+smbORfKmPE6KnF2g@mail.gmail.com>
	<53480138.2080805@free.fr>
	<53733AB4.7010500@free.fr>
	<20140514215126.GA15419@us.netrek.org>
	<CAJwzM1k+75qRJaONyehMNPaOqOHyBhryMGBtZ4NpD6jGHk-cHQ@mail.gmail.com>
	<20140515214105.GG15430@us.netrek.org>
Date: Fri, 16 May 2014 09:51:11 +0530
Message-ID: <CAJwzM1k4ysc0BGefqPWB1_-7moE=4z_hjrB=--xRj8iWma5krQ@mail.gmail.com> (sfid-20140516_062116_007271_AE093D20)
Subject: Re: Mwifiex driver on Globalscale Mirabox
From: Avinash Patil <avinashapatil@gmail.com>
To: James Cameron <quozl@laptop.org>
Cc: WebAV <webav@free.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

Yes; extended scan command 0x107 is supported on SD8787 p96 FW.

Thanks,
Avinash

On Fri, May 16, 2014 at 3:11 AM, James Cameron <quozl@laptop.org> wrote:
> On Thu, May 15, 2014 at 07:36:29PM +0530, Avinash Patil wrote:
>> If an unsupported command is downloaded to FW, it results into
>> command response not supported - code 0x2.
>
> Thanks.  Is 0x107 supported on 14.66.9.p96?
>
> --
> James Cameron
> http://quozl.linux.org.au/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:47729 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYG1TIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 15:08:54 -0400
Received: by rv-out-0506.google.com with SMTP id k40so4608463rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 12:08:53 -0700 (PDT)
Message-ID: <1ba2fa240807281208r25e3746dt550d95cac3381ede@mail.gmail.com> (sfid-20080728_210912_775808_AAB758BD)
Date: Mon, 28 Jul 2008 22:08:53 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Angel Mieres" <mieres.angel@gmail.com>
Subject: Re: IWL5000
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <5f68ea7b0807281157v7cad2424rd8d46c1ca7d7d753@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5f68ea7b0807280351u4f6b6a59v8304a7a3b53436be@mail.gmail.com>
	 <1ba2fa240807280421s48b26b58n8db03f75bfa4c206@mail.gmail.com>
	 <1ba2fa240807280421x58b72273x7b148e796e4f2c87@mail.gmail.com>
	 <5f68ea7b0807280446w4009375dw4c77357cae964e1a@mail.gmail.com>
	 <5f68ea7b0807281157v7cad2424rd8d46c1ca7d7d753@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 28, 2008 at 9:57 PM, Angel Mieres <mieres.angel@gmail.com> wrote:
> Hi Tomas,
>
> With the master branch, i recompile the kernel and it works. so now i
> know that my problem is not in the NIC.
> Is possible to get working this nic without having to recompile a
> kernel? only with compat-wireless?

In general it's possible. I a little work is needed there as I've
renamed the module name.
Tomas

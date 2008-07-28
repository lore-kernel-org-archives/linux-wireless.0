Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:24263 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060AbYG1Une (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 16:43:34 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1579809nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 13:43:31 -0700 (PDT)
Message-ID: <5f68ea7b0807281343qb777e60hae5c24f3307b167f@mail.gmail.com> (sfid-20080728_224357_707550_9E85AE2C)
Date: Mon, 28 Jul 2008 22:43:31 +0200
From: "Angel Mieres" <mieres.angel@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: IWL5000
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807281208r25e3746dt550d95cac3381ede@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5f68ea7b0807280351u4f6b6a59v8304a7a3b53436be@mail.gmail.com>
	 <1ba2fa240807280421s48b26b58n8db03f75bfa4c206@mail.gmail.com>
	 <1ba2fa240807280421x58b72273x7b148e796e4f2c87@mail.gmail.com>
	 <5f68ea7b0807280446w4009375dw4c77357cae964e1a@mail.gmail.com>
	 <5f68ea7b0807281157v7cad2424rd8d46c1ca7d7d753@mail.gmail.com>
	 <1ba2fa240807281208r25e3746dt550d95cac3381ede@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh i see, now loads iwlagn module. So, this will be soon in compat-wireless?
Im trying to get this working without the kernel compilation because
im trying to do a home made firewall with ubuntu kernel.
My actual kernel have some features that this don't have so,
compat-wireless will be perfect for me.

Thanks a lot Tomas!

2008/7/28 Tomas Winkler <tomasw@gmail.com>:
> On Mon, Jul 28, 2008 at 9:57 PM, Angel Mieres <mieres.angel@gmail.com> wrote:
>> Hi Tomas,
>>
>> With the master branch, i recompile the kernel and it works. so now i
>> know that my problem is not in the NIC.
>> Is possible to get working this nic without having to recompile a
>> kernel? only with compat-wireless?
>
> In general it's possible. I a little work is needed there as I've
> renamed the module name.
> Tomas
>
